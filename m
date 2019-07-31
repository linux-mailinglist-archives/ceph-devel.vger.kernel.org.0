Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEEC07B7C3
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Jul 2019 03:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfGaBt6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jul 2019 21:49:58 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33172 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaBt6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Jul 2019 21:49:58 -0400
Received: by mail-ot1-f68.google.com with SMTP id q20so68386885otl.0
        for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2019 18:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WSaLd/fJFUjhlKeebNoDC6TOmLU1ICGiMHNGccSaTwM=;
        b=jL1Nq/YZ+BV1ifv6DNFqMtrbvzfGcu18qJYnR7i3WrvPJwIU31/RGr+A118B8BZu9/
         yROyFGh/HsGzRYtuK5rK3wvlkDDc5jMeHjgA8JIf27wOtEYng/pGJimW05THVDBMt2ZR
         UZ6i7sOxUu14jDHtCTqfFBuMZEro72GUQkTxc39+jWMMpGC/ntX/sz7cwn9WCvrYxsq1
         Goa7Ot7I68bs+SqrOUUJNgQJkVoICiZUU3mX6dvuqIBXXWijnFdemsWvBdXrTDASKjx+
         mYxI4F0cDypKqGGiDUpMGGQhEPSo4gEbMUvSC2AoyMO2HHSMwspn6nk9EIqrgw+HCfX7
         t0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WSaLd/fJFUjhlKeebNoDC6TOmLU1ICGiMHNGccSaTwM=;
        b=aVZL6U9oZd8tQ0SRDVNRDB96eV4zH9b7WTB3tw7lxD9qgjd2ZOdFbQViM6JACBR6HT
         I2kbXBDSB6Ir5lFbuZoCViMC3eLk4lWPgNji1mqEi2LIkx/eLf9VwZqP50WFuagpbYBM
         5S47t3AHWzx4S9In4H4DuXNrj2HqBniifWHKYLP9imDlN9RN/bzNO9by9ovqfditS2mv
         PC1R0QJb4SeytWHYhSv6hBfuFqHlWUY7cA7AtvyRBvxGAMPrGnrcZy7YrLigAzTv/T6s
         lS+jADln+3KibEp0NE7v450sB6y1Ps6OUNxcg07Fy5aPDI5DjsTPppVWG/8dANIQm8A/
         tO3w==
X-Gm-Message-State: APjAAAVlua5i+hVGh84TqthXMZsTI4bhfvg33hY0qD3J9bae4mOZtOGP
        JseoCrBAFWw/QOlPJPiAD8yhb8nrxjSYFTqHEkc=
X-Google-Smtp-Source: APXvYqyfrdAT4sGm3N+Bett4tyvXq5QQdmUel4k+aOG3VFEyJBnfBtp6KwJwJ40HjJowrJTXVO8hrDWLZ1FzxeZJUrs=
X-Received: by 2002:a9d:65da:: with SMTP id z26mr75919883oth.257.1564537797312;
 Tue, 30 Jul 2019 18:49:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fsGD4b_RE1yF3RQszne+xrcEVV9QZiObwwZ39GDCh6n5Q@mail.gmail.com>
 <CAAM7YAmd+63fAO8EPvw4jE0=ZUZAW2nOQhkmuYcXLhdEPeV-dA@mail.gmail.com>
 <CAKQB+fsbPXvmGj11NW0nJ50VGJeWkTc7vfpDZ0a6Jrw2DOWSgA@mail.gmail.com>
 <CAKQB+fuoAmSzsFmJz2ou5Rp6jGKv6XSpfo08t2C+Hj6_yb2+_A@mail.gmail.com>
 <CAOi1vP-6Xd_jrnRf-Q7qL0SKUQ3kXHuKfOUmx_uYqQEX6R=PJQ@mail.gmail.com>
 <CAKQB+fsCpkWf=OfVPiQ8Fq159g+X7v33fvTV85pwUErUzA=dzA@mail.gmail.com> <CAOi1vP8bSFvh600_q7SiMnOkV0BTKutD=qKP66Lh0FcNtH0kLw@mail.gmail.com>
In-Reply-To: <CAOi1vP8bSFvh600_q7SiMnOkV0BTKutD=qKP66Lh0FcNtH0kLw@mail.gmail.com>
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Wed, 31 Jul 2019 09:49:43 +0800
Message-ID: <CAKQB+ftuKxkkBN73rQx5x7-oqy=39fAac-4M-P0m3vm6KMZXew@mail.gmail.com>
Subject: Re: cephfs kernel client umount stucks forever
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 30 Jul 2019 at 23:02, Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Tue, Jul 30, 2019 at 11:20 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> >
> > Hello Ilya,
> >
> > On Mon, 29 Jul 2019 at 16:42, Ilya Dryomov <idryomov@gmail.com> wrote:
> > >
> > > On Fri, Jul 26, 2019 at 11:23 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > > >
> > > > Some additional information are provided as below:
> > > >
> > > > I tried to restart the active MDS, and after the standby MDS took
> > > > over, there is no client session recorded in the output of `ceph
> > > > daemon mds.xxx session ls`.  When I restarted the OSD.13 daemon, the
> > > > stuck write op finished immediately.  Thanks.
> > >
> > > So it happened again with the same OSD?  Did you see this with other
> > > OSDs?
> >
> > Yes.  The issue always happened on the same OSD from previous
> > experience.  However, it did happen with other OSD on other node from
> > the Cephfs kernel client's point of view.
>
> Hi Jerry,
>
> I'm not sure what you mean by "it did happen with other OSD on other
> node from the Cephfs kernel client's point of view".
>

Hi Ilya,

Sorry, it simply means that I had only seen OSD on Node2 and Node3
shown in the osdc debug output when encountering the issue but I
didn't seen stuck write op sent to OSD on Node1.  So, in the
beginning, I think that there might be some network connection issues
among nodes.

Node1 (where the kernel client umount stuck)
   - OSD.0
   - OSD.1
   - ...
Node2
   - OSD.5
   - OSD.6
   - ...
Node3
   - OSD.10
   - OSD.11
   - ...

> >
> > >
> > > Try enabling some logging on osd.13 since this seems to be a recurring
> > > issue.  At least "debug ms = 1" so we can see whether it ever sends the
> > > reply to the original op (i.e. prior to restart).
> >
> > Get it, I will raise the debug level to retrive more logs for further
> > investigateion.
> >
> > >
> > > Also, take note of the epoch in osdc output:
> > >
> > > 36      osd13   ... e327 ...
> > >
> > > Does "ceph osd dump" show the same epoch when things are stuck?
> > >
> >
> > Unfortunately, the environment was gone.  But from the logs captured
> > before, the epoch seems to be consistent between client and ceph
> > cluster when thing are stuck, right?
> >
> > 2019-07-26 12:24:08.475 7f06efebc700  0 log_channel(cluster) log [DBG]
> > : osdmap e306: 15 total, 15 up, 15 in
> >
> > BTW, logs of OSD.13 and dynamic debug kernel logs of libceph captured
> > on the stuck node are provided in
> > https://drive.google.com/drive/folders/1gYksDbCecisWtP05HEoSxevDK8sywKv6?usp=sharing.
>
> The libceph log confirms that it had two laggy requests but it ends
> before you restarted the OSD.  The OSD log is useless: we really need
> to see individual ops coming in and replies going out.  It appears that
> the OSD simply dropped those ops expecting the kernel to resend them
> but that didn't happen for some reason.

Thanks for the analysis.  I will raise the debug level and hope more
clues can be capatured.

- Jerry

>
> Thanks,
>
>                 Ilya
