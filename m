Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A67F78CF
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Nov 2019 17:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfKKQak (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Nov 2019 11:30:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:57020 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726871AbfKKQak (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 11 Nov 2019 11:30:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 72E0CB3F1;
        Mon, 11 Nov 2019 16:30:37 +0000 (UTC)
Date:   Mon, 11 Nov 2019 16:30:36 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Sage Weil <sage@newdream.net>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] ceph: safely use 'copy-from' Op on Octopus OSDs
Message-ID: <20191111163036.GA20513@hermes.olymp>
References: <20191108141555.31176-1-lhenriques@suse.com>
 <CAOi1vP-sVQKvpiPLoZ=9s7Hy=c2eQRocxSs1nPrXAUCbbZUZ-g@mail.gmail.com>
 <20191108164758.GA1760@hermes.olymp>
 <alpine.DEB.2.21.1911081656320.10553@piezo.novalocal>
 <20191108171616.GA2569@hermes.olymp>
 <alpine.DEB.2.21.1911081721120.28682@piezo.novalocal>
 <20191108173101.GA3300@hermes.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191108173101.GA3300@hermes.olymp>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Nov 08, 2019 at 05:31:01PM +0000, Luis Henriques wrote:
<snip>
> > - You'll need to add it for both OSDMap::Incremental and OSDMap
> > - You'll need to make the encoding condition by updating the block like 
> > the one below from OSDMap::encode()
> > 
> >     uint8_t v = 9;
> >     if (!HAVE_FEATURE(features, SERVER_LUMINOUS)) {
> >       v = 3;
> >     } else if (!HAVE_FEATURE(features, SERVER_MIMIC)) {
> >       v = 6;
> >     } else if (!HAVE_FEATURE(features, SERVER_NAUTILUS)) {
> >       v = 7;
> >     }
> > 
> > to include a SERVER_OCTOPUS case too.  Same goes for Incremental::encode()
> 
> Awesome, thanks!  I'll give it a try, and test it with the appropriate
> kernel client side changes to use this.

Ok, I've got the patch bellow for the OSD code, which IIRC should do
exactly what we want: duplicate the require_osd_release in the client
side.

Now, in order to quickly test this I've started adding flags to the
CEPH_FEATURES_SUPPORTED_DEFAULT definition.  SERVER_MIMIC *seemed* to be
Ok, but once I've added SERVER_NAUTILUS I've realized that we'll need to
handle TYPE_MSGR2 address.  Which is a _big_ thing.  Is anyone already
looking into adding support for msgr v2 to the kernel client?

Cheers,
--
Luís

diff --git a/src/osd/OSDMap.cc b/src/osd/OSDMap.cc
index 6b5930743a33..b38d91d98fcf 100644
--- a/src/osd/OSDMap.cc
+++ b/src/osd/OSDMap.cc
@@ -555,13 +555,15 @@ void OSDMap::Incremental::encode(ceph::buffer::list& bl, uint64_t features) cons
   ENCODE_START(8, 7, bl);
 
   {
-    uint8_t v = 8;
+    uint8_t v = 9;
     if (!HAVE_FEATURE(features, SERVER_LUMINOUS)) {
       v = 3;
     } else if (!HAVE_FEATURE(features, SERVER_MIMIC)) {
       v = 5;
     } else if (!HAVE_FEATURE(features, SERVER_NAUTILUS)) {
       v = 6;
+    } else if (!HAVE_FEATURE(features, SERVER_OCTOPUS)) {
+      v = 8;
     }
     ENCODE_START(v, 1, bl); // client-usable data
     encode(fsid, bl);
@@ -611,6 +613,9 @@ void OSDMap::Incremental::encode(ceph::buffer::list& bl, uint64_t features) cons
       encode(new_last_up_change, bl);
       encode(new_last_in_change, bl);
     }
+    if (v >= 9) {
+      encode(new_require_osd_release, bl);
+    }
     ENCODE_FINISH(bl); // client-usable data
   }
 
@@ -816,7 +821,7 @@ void OSDMap::Incremental::decode(ceph::buffer::list::const_iterator& bl)
     return;
   }
   {
-    DECODE_START(8, bl); // client-usable data
+    DECODE_START(9, bl); // client-usable data
     decode(fsid, bl);
     decode(epoch, bl);
     decode(modified, bl);
@@ -2847,13 +2852,15 @@ void OSDMap::encode(ceph::buffer::list& bl, uint64_t features) const
   {
     // NOTE: any new encoding dependencies must be reflected by
     // SIGNIFICANT_FEATURES
-    uint8_t v = 9;
+    uint8_t v = 10;
     if (!HAVE_FEATURE(features, SERVER_LUMINOUS)) {
       v = 3;
     } else if (!HAVE_FEATURE(features, SERVER_MIMIC)) {
       v = 6;
     } else if (!HAVE_FEATURE(features, SERVER_NAUTILUS)) {
       v = 7;
+    } else if (!HAVE_FEATURE(features, SERVER_OCTOPUS)) {
+      v = 9;
     }
     ENCODE_START(v, 1, bl); // client-usable data
     // base
@@ -2929,6 +2936,9 @@ void OSDMap::encode(ceph::buffer::list& bl, uint64_t features) const
       encode(last_up_change, bl);
       encode(last_in_change, bl);
     }
+    if (v >= 10) {
+      encode(require_osd_release, bl);
+    }
     ENCODE_FINISH(bl); // client-usable data
   }
 
@@ -3170,7 +3180,7 @@ void OSDMap::decode(ceph::buffer::list::const_iterator& bl)
    * Since we made it past that hurdle, we can use our normal paths.
    */
   {
-    DECODE_START(9, bl); // client-usable data
+    DECODE_START(10, bl); // client-usable data
     // base
     decode(fsid, bl);
     decode(epoch, bl);
