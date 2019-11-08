Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B08F5293
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Nov 2019 18:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfKHRbF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Nov 2019 12:31:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:57938 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726200AbfKHRbE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 8 Nov 2019 12:31:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 06EAAB469;
        Fri,  8 Nov 2019 17:31:03 +0000 (UTC)
Date:   Fri, 8 Nov 2019 17:31:01 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Sage Weil <sage@newdream.net>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] ceph: safely use 'copy-from' Op on Octopus OSDs
Message-ID: <20191108173101.GA3300@hermes.olymp>
References: <20191108141555.31176-1-lhenriques@suse.com>
 <CAOi1vP-sVQKvpiPLoZ=9s7Hy=c2eQRocxSs1nPrXAUCbbZUZ-g@mail.gmail.com>
 <20191108164758.GA1760@hermes.olymp>
 <alpine.DEB.2.21.1911081656320.10553@piezo.novalocal>
 <20191108171616.GA2569@hermes.olymp>
 <alpine.DEB.2.21.1911081721120.28682@piezo.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.21.1911081721120.28682@piezo.novalocal>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Nov 08, 2019 at 05:22:28PM +0000, Sage Weil wrote:
> On Fri, 8 Nov 2019, Luis Henriques wrote:
> > On Fri, Nov 08, 2019 at 04:57:27PM +0000, Sage Weil wrote:
> > > On Fri, 8 Nov 2019, Luis Henriques wrote:
> > > > On Fri, Nov 08, 2019 at 04:15:35PM +0100, Ilya Dryomov wrote:
> > > > > If the OSD checked for unknown flags, like newer syscalls do, it would
> > > > > be super easy, but it looks like it doesn't.
> > > > > 
> > > > > An obvious solution is to look at require_osd_release in osdmap, but we
> > > > > don't decode that in the kernel because it lives the OSD portion of the
> > > > > osdmap.  We could add that and consider the fact that the client now
> > > > > needs to decode more than just the client portion a design mistake.
> > > > > I'm not sure what can of worms does that open and if copy-from alone is
> > > > > worth it though.  Perhaps that field could be moved to (or a copy of it
> > > > > be replicated in) the client portion of the osdmap starting with
> > > > > octopus?  We seem to be running into it on the client side more and
> > > > > more...
> > > > 
> > > > I can't say I'm thrilled with the idea of going back to hack into the
> > > > OSDs code again, I was hoping to be able to handle this with the
> > > > information we already have on the connection peer_features field.  It
> > > > took me *months* to have the OSD fix merged in so I'm not really
> > > > convinced a change to the osdmap would make it into Octopus :-)
> > > > 
> > > > (But I'll have a look at this and see if I can understand what moving or
> > > > replicating the field in the osdmap would really entail.)
> > > 
> > > Adding a copy of require_osd_release in the client portion of the map is 
> > > an easy thing to do (and probably where it should have gone in the first 
> > > place!).  Let's do that!
> > 
> > Yeah, after sending my reply to Ilya I took a quick look and it _seems_
> > to be as easy as adding a new encode(require_osd_release...) in the
> > OSDMap.  And handle the versions, of course.  Let me spend some time
> > playing with that and I'll try to come up with something during the next
> > few days.
> 
> - You'll need to add it for both OSDMap::Incremental and OSDMap
> - You'll need to make the encoding condition by updating the block like 
> the one below from OSDMap::encode()
> 
>     uint8_t v = 9;
>     if (!HAVE_FEATURE(features, SERVER_LUMINOUS)) {
>       v = 3;
>     } else if (!HAVE_FEATURE(features, SERVER_MIMIC)) {
>       v = 6;
>     } else if (!HAVE_FEATURE(features, SERVER_NAUTILUS)) {
>       v = 7;
>     }
> 
> to include a SERVER_OCTOPUS case too.  Same goes for Incremental::encode()

Awesome, thanks!  I'll give it a try, and test it with the appropriate
kernel client side changes to use this.

Cheers,
--
Luís
