Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1FC1F8D13
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Nov 2019 11:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfKLKmT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 Nov 2019 05:42:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:47140 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725874AbfKLKmT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 05:42:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2A272AD22;
        Tue, 12 Nov 2019 10:42:17 +0000 (UTC)
Date:   Tue, 12 Nov 2019 10:42:16 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@newdream.net>, Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] ceph: safely use 'copy-from' Op on Octopus OSDs
Message-ID: <20191112104216.GA2028@hermes.olymp>
References: <20191108141555.31176-1-lhenriques@suse.com>
 <CAOi1vP-sVQKvpiPLoZ=9s7Hy=c2eQRocxSs1nPrXAUCbbZUZ-g@mail.gmail.com>
 <20191108164758.GA1760@hermes.olymp>
 <alpine.DEB.2.21.1911081656320.10553@piezo.novalocal>
 <20191108171616.GA2569@hermes.olymp>
 <alpine.DEB.2.21.1911081721120.28682@piezo.novalocal>
 <20191108173101.GA3300@hermes.olymp>
 <20191111163036.GA20513@hermes.olymp>
 <CAOi1vP-kFnu_mJaTERHbSjBxQRvfXhFWF=9_nCaaFbh7ACiVhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP-kFnu_mJaTERHbSjBxQRvfXhFWF=9_nCaaFbh7ACiVhg@mail.gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Nov 11, 2019 at 09:51:47PM +0100, Ilya Dryomov wrote:
> On Mon, Nov 11, 2019 at 5:30 PM Luis Henriques <lhenriques@suse.com> wrote:
> >
> > On Fri, Nov 08, 2019 at 05:31:01PM +0000, Luis Henriques wrote:
> > <snip>
> > > > - You'll need to add it for both OSDMap::Incremental and OSDMap
> > > > - You'll need to make the encoding condition by updating the block like
> > > > the one below from OSDMap::encode()
> > > >
> > > >     uint8_t v = 9;
> > > >     if (!HAVE_FEATURE(features, SERVER_LUMINOUS)) {
> > > >       v = 3;
> > > >     } else if (!HAVE_FEATURE(features, SERVER_MIMIC)) {
> > > >       v = 6;
> > > >     } else if (!HAVE_FEATURE(features, SERVER_NAUTILUS)) {
> > > >       v = 7;
> > > >     }
> > > >
> > > > to include a SERVER_OCTOPUS case too.  Same goes for Incremental::encode()
> > >
> > > Awesome, thanks!  I'll give it a try, and test it with the appropriate
> > > kernel client side changes to use this.
> >
> > Ok, I've got the patch bellow for the OSD code, which IIRC should do
> > exactly what we want: duplicate the require_osd_release in the client
> > side.
> >
> > Now, in order to quickly test this I've started adding flags to the
> > CEPH_FEATURES_SUPPORTED_DEFAULT definition.  SERVER_MIMIC *seemed* to be
> > Ok, but once I've added SERVER_NAUTILUS I've realized that we'll need to
> > handle TYPE_MSGR2 address.  Which is a _big_ thing.  Is anyone already
> > looking into adding support for msgr v2 to the kernel client?
> 
> It should be easy enough to hack around it for testing purposes.
>
> I made some initial steps and hope to be able to dedicate the 5.6 cycle
> to it.

Yeah, I'll give that a try; adding support for that new address type
shouldn't be a big deal.  I was just wondering if that wasn't already
being handling by any new msgrv2 code under development.  Thanks, Ilya.

Cheers,
--
Luís
