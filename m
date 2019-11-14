Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9F4FC9DC
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 16:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKNPYx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 10:24:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:49326 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbfKNPYx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 10:24:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3ABE7AD19;
        Thu, 14 Nov 2019 15:24:51 +0000 (UTC)
Date:   Thu, 14 Nov 2019 15:24:50 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Sage Weil <sweil@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Gregory Farnum <gfarnum@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/4] ceph: safely use 'copy-from' Op on Octopus
 OSDs
Message-ID: <20191114152450.GA6902@hermes.olymp>
References: <20191114105736.8636-1-lhenriques@suse.com>
 <cbda3a69d25b04e10332e7b3898064a93b2d04ae.camel@kernel.org>
 <alpine.DEB.2.21.1911141326260.17979@piezo.novalocal>
 <CAOi1vP9XaeJdqV-jMP3BM=mjHKqJW8-ynAjCi0xcDD3DtL94KQ@mail.gmail.com>
 <alpine.DEB.2.21.1911141416040.17979@piezo.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.21.1911141416040.17979@piezo.novalocal>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 14, 2019 at 02:17:44PM +0000, Sage Weil wrote:
> On Thu, 14 Nov 2019, Ilya Dryomov wrote:
> > > > I'm just getting caught up on the discussion here, but why was it
> > > > decided to do it this way instead of just adding a new OSD
> > > > "copy-from-no-truncseq" operation? Once you tried it once and an OSD
> > > > didn't support it, you could just give up on using it any longer? That
> > > > seems a lot simpler than trying to monkey with feature bits.
> > >
> > > I don't remember the original discussion either, but in retrospect that
> > > does seem much simpler--especially since hte client is conditioning
> > > sending this based on the the require_osd_release.  It seems like passing
> > > a flag to the copy-from op would be more reasonable instead of conditional
> > > feature-based behavior.
> > 
> > Yeah, I suggested adding require_osd_release to the client portion just
> > because we are running into it more and more: Objecter relies on it for
> > RESEND_ON_SPLIT for example.  It needs to be accessible so that patches
> > like that can be carried over to the kernel client without workarounds.
> > 
> > copy-from in its existing form is another example.  AFAIU the problem
> > is that copy-from op doesn't reject unknown flags.  Luis added a flag
> > in https://github.com/ceph/ceph/pull/25374, but it is simply ignored on
> > nautilus and older releases, potentially leading to data corruption.
> > 
> > Adding a new op that would be an alias for CEPH_OSD_OP_COPY_FROM with
> > CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ like Jeff is suggesting, or a new
> > copy-from2 op that would behave just like copy-from, but reject unknown
> > flags to avoid similar compatibility issues in the future is probably
> > the best thing we can do from the client perspective.
> 
> Yeah, I think copy-from2 is the best path.  I think that means we should 
> revert what we merged to ceph.git a few weeks back, Luis!  Sorry we didn't 
> put all the pieces together before...

Well, that's an unexpected turn.  I'm not disagreeing with that decision
but since my initial pull request was done one year ago (almost to the
day!), it's a bit disappointing to see that in the end I'm back to
square one :-)

I guess that the PR I mentioned in the cover letter can also be dropped,
as it's not really usable by the kernel client (at least not until it
fully supports all the features up to SERVER_OCTOPUS).

Anyway, thanks everyone for the review.

Cheers,
--
Luís
