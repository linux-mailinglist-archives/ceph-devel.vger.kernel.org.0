Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE04FCA2D
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 16:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfKNPqf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 10:46:35 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:37271 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfKNPqf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 14 Nov 2019 10:46:35 -0500
Received: by mail-io1-f68.google.com with SMTP id 1so7321684iou.4;
        Thu, 14 Nov 2019 07:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xOIHTfBLTMB4ZoLauAEk7jGm1OPQ6xnkIWbsYKNK/Go=;
        b=mugySPOoxB8TWmIsctCqLuW1W60V4RQLkLr9y2CrKpWldwcbogZtAwdw4r1H7aI4GI
         X69YpnWUU6MMvvTGzRkRxWZUJwJ63M0E5SDaTG/sNTcXVKpYsr/T74VYoY4Si3xVUU8A
         Zv2opc76RjdF/GPIrwuQtClY24bL8EVy3Xz+eXQxS3VPmGK/Svb7aC95V4eN9tmRjEfN
         MuUJZfE8DRfdKKiXPvBSzNo1CJBrZjvOEXtHZGk1oOxx3R/mAr9AB+yNQMMP7wv7xCO6
         blrdskMnH+wI9nFFH9GpfhQBXh0lvMOPR0WojAnShU5SIkEjRro1DTFR5QoRlKjBkkMs
         MCSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xOIHTfBLTMB4ZoLauAEk7jGm1OPQ6xnkIWbsYKNK/Go=;
        b=fj8GNgLBCZb8BAKGPudqsBcAc+wWFuk1SbaikFIrbHLOCXZMgBAEkOnjLl/YNtgymG
         ns6oCCQDh/ELC1NI0AiA8LuqhPaFLmoh92Ozd4L+FSw/bl3nRvx9hMhKbc1X1fk719ME
         B9fVOdtrkiSZHaNyn8yov7gVCETAH+n6st2F8prqoTZCfjBvdBktR4kOVB0GtuuhyMQT
         5BUe4Q75KvdqBaULk999sZ1Xga7l7IQNGaXACSfTfpX+zejEh95XuRSTdm6pWg7gBv4f
         w9cLJaoUvyNSqoDhA7w4d3nEoyYsqN/2eJgWtF+qUDeaCTkhIgBJwStNYtU8HmA1ZwMn
         CUQg==
X-Gm-Message-State: APjAAAUq4VVzTQVF3bmktJKfsYJMeVcjYW1uvoBNsK8ey8Q0ZlKqW1/q
        /SU/21hz/MQcIsdIad+6zYqqMJ3EpdHKHDt8NHk=
X-Google-Smtp-Source: APXvYqxED6h0fNFN4w1dvWOm28RohkY/9NELaLWTvjMYQmMZUqmeyBP3fL1JGc3TMdpEZ+QD6YTh4YbRNPN0P5nDU2E=
X-Received: by 2002:a5e:9741:: with SMTP id h1mr8806846ioq.143.1573746394533;
 Thu, 14 Nov 2019 07:46:34 -0800 (PST)
MIME-Version: 1.0
References: <20191114105736.8636-1-lhenriques@suse.com> <cbda3a69d25b04e10332e7b3898064a93b2d04ae.camel@kernel.org>
 <alpine.DEB.2.21.1911141326260.17979@piezo.novalocal> <CAOi1vP9XaeJdqV-jMP3BM=mjHKqJW8-ynAjCi0xcDD3DtL94KQ@mail.gmail.com>
 <alpine.DEB.2.21.1911141416040.17979@piezo.novalocal> <20191114152450.GA6902@hermes.olymp>
In-Reply-To: <20191114152450.GA6902@hermes.olymp>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 14 Nov 2019 16:47:02 +0100
Message-ID: <CAOi1vP8YWdN=bOVcHq5j4x9iv+JuO8vd3zEkmVE_Pc-BC8dSAQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] ceph: safely use 'copy-from' Op on Octopus OSDs
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Sage Weil <sweil@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Gregory Farnum <gfarnum@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 14, 2019 at 4:24 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> On Thu, Nov 14, 2019 at 02:17:44PM +0000, Sage Weil wrote:
> > On Thu, 14 Nov 2019, Ilya Dryomov wrote:
> > > > > I'm just getting caught up on the discussion here, but why was it
> > > > > decided to do it this way instead of just adding a new OSD
> > > > > "copy-from-no-truncseq" operation? Once you tried it once and an OSD
> > > > > didn't support it, you could just give up on using it any longer? That
> > > > > seems a lot simpler than trying to monkey with feature bits.
> > > >
> > > > I don't remember the original discussion either, but in retrospect that
> > > > does seem much simpler--especially since hte client is conditioning
> > > > sending this based on the the require_osd_release.  It seems like passing
> > > > a flag to the copy-from op would be more reasonable instead of conditional
> > > > feature-based behavior.
> > >
> > > Yeah, I suggested adding require_osd_release to the client portion just
> > > because we are running into it more and more: Objecter relies on it for
> > > RESEND_ON_SPLIT for example.  It needs to be accessible so that patches
> > > like that can be carried over to the kernel client without workarounds.
> > >
> > > copy-from in its existing form is another example.  AFAIU the problem
> > > is that copy-from op doesn't reject unknown flags.  Luis added a flag
> > > in https://github.com/ceph/ceph/pull/25374, but it is simply ignored on
> > > nautilus and older releases, potentially leading to data corruption.
> > >
> > > Adding a new op that would be an alias for CEPH_OSD_OP_COPY_FROM with
> > > CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ like Jeff is suggesting, or a new
> > > copy-from2 op that would behave just like copy-from, but reject unknown
> > > flags to avoid similar compatibility issues in the future is probably
> > > the best thing we can do from the client perspective.
> >
> > Yeah, I think copy-from2 is the best path.  I think that means we should
> > revert what we merged to ceph.git a few weeks back, Luis!  Sorry we didn't
> > put all the pieces together before...
>
> Well, that's an unexpected turn.  I'm not disagreeing with that decision
> but since my initial pull request was done one year ago (almost to the
> day!), it's a bit disappointing to see that in the end I'm back to
> square one :-)

Well, I think literally every line from that PR will still go in, just
wrapped in a new OSD op.  Backwards compatibility is hard...

>
> I guess that the PR I mentioned in the cover letter can also be dropped,
> as it's not really usable by the kernel client (at least not until it
> fully supports all the features up to SERVER_OCTOPUS).

No, some form of https://github.com/ceph/ceph/pull/31611 should go in.
I'm pretty certain it will come up at some point in the future, even if
the new field isn't immediately usable today.  Someone porting a change
to the kernel client a couple years from now will thank you for it ;)

Thanks,

                Ilya
