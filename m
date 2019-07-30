Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4567ABD6
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2019 17:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731928AbfG3PCE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jul 2019 11:02:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34815 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730274AbfG3PCE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Jul 2019 11:02:04 -0400
Received: by mail-io1-f68.google.com with SMTP id k8so128826857iot.1
        for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2019 08:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TX4cM7SbAOrMoR83f2VqHS09S2ytNB1eGNkrG7/uN5A=;
        b=R6+63yagElfhjKNQzPnPTBcq+29J3Cd4ff7luVZCbtI98Pd32NQj8gi9hcw2CPL/Z8
         DVBAn/MR51S48DNhLr5/5l16rBlvQU82yo07JcMmwWBFfpFLZW7tMBUj5oYigUGYMF4q
         Dqt2L3ymduVHIOHF2fO8zSUr/uF373GUtdvjfzU8Z8TBUypWLJ+bA8l2uEzWejHIoK4D
         +RWa9Y1k3jnKheFkxuRgIncZ4RBYpP1M27MFGzt7BE1QXQ80gNNqwuQRrGv/NgMwBerG
         3w+gcONEX8j+YKf3G+yKTdv8ZzauoFpvmphZmu+9Fvy8915tKU1x+LjO1lr2Jzo57bDW
         wESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TX4cM7SbAOrMoR83f2VqHS09S2ytNB1eGNkrG7/uN5A=;
        b=NhOTUdk1gZ0O1rzejkV5thmtjFPWNiFRlN4VxP77zuYHezAkEVCRT6DhChRMfllUNN
         HLI82Dr6bLNA0Tk7k29MtDdU5DsHK9oOXUrNuwvpwTInOmL5R13CCW8tfY/3TerpYitM
         a8qI4He/SKJRsIQsGYNSWkN32U83d3r2d97Mw0eXHhdNRYqcDWahN5htbNwjGPpR4HI1
         /zIvcOMC4JfDDhCV+3KFX3tUa5GGdyzr2xkWnfsVPVQJXhJ3VbZALTs37dEmUtSMFOGH
         ZXZlKa4q0IwajVZmcmKPGe2Wng5XaB/nuHWhpYrg6Fju9GG4S1pV3QrFmzYQNXCL499L
         bCrQ==
X-Gm-Message-State: APjAAAVDlWuux0lsc3bGK9VV1SHqNXTcCy56WKkzRCbf/PloQhtglUPW
        PxxSCPzMonZIAdd7I4rhzFLAqUczZnBcV26P6lE=
X-Google-Smtp-Source: APXvYqyAKX3CcuW+EEoGDMg6zXZEWTjV+fGut7+rr+Cp3viARiZuuOoRYgIimf45iz2yxPsAobvgA3E7tS3WxNtl+EM=
X-Received: by 2002:a02:5a89:: with SMTP id v131mr122942515jaa.130.1564498923490;
 Tue, 30 Jul 2019 08:02:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fsGD4b_RE1yF3RQszne+xrcEVV9QZiObwwZ39GDCh6n5Q@mail.gmail.com>
 <CAAM7YAmd+63fAO8EPvw4jE0=ZUZAW2nOQhkmuYcXLhdEPeV-dA@mail.gmail.com>
 <CAKQB+fsbPXvmGj11NW0nJ50VGJeWkTc7vfpDZ0a6Jrw2DOWSgA@mail.gmail.com>
 <CAKQB+fuoAmSzsFmJz2ou5Rp6jGKv6XSpfo08t2C+Hj6_yb2+_A@mail.gmail.com>
 <CAOi1vP-6Xd_jrnRf-Q7qL0SKUQ3kXHuKfOUmx_uYqQEX6R=PJQ@mail.gmail.com> <CAKQB+fsCpkWf=OfVPiQ8Fq159g+X7v33fvTV85pwUErUzA=dzA@mail.gmail.com>
In-Reply-To: <CAKQB+fsCpkWf=OfVPiQ8Fq159g+X7v33fvTV85pwUErUzA=dzA@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 30 Jul 2019 17:04:57 +0200
Message-ID: <CAOi1vP8bSFvh600_q7SiMnOkV0BTKutD=qKP66Lh0FcNtH0kLw@mail.gmail.com>
Subject: Re: cephfs kernel client umount stucks forever
To:     Jerry Lee <leisurelysw24@gmail.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jul 30, 2019 at 11:20 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
>
> Hello Ilya,
>
> On Mon, 29 Jul 2019 at 16:42, Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > On Fri, Jul 26, 2019 at 11:23 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > >
> > > Some additional information are provided as below:
> > >
> > > I tried to restart the active MDS, and after the standby MDS took
> > > over, there is no client session recorded in the output of `ceph
> > > daemon mds.xxx session ls`.  When I restarted the OSD.13 daemon, the
> > > stuck write op finished immediately.  Thanks.
> >
> > So it happened again with the same OSD?  Did you see this with other
> > OSDs?
>
> Yes.  The issue always happened on the same OSD from previous
> experience.  However, it did happen with other OSD on other node from
> the Cephfs kernel client's point of view.

Hi Jerry,

I'm not sure what you mean by "it did happen with other OSD on other
node from the Cephfs kernel client's point of view".

>
> >
> > Try enabling some logging on osd.13 since this seems to be a recurring
> > issue.  At least "debug ms = 1" so we can see whether it ever sends the
> > reply to the original op (i.e. prior to restart).
>
> Get it, I will raise the debug level to retrive more logs for further
> investigateion.
>
> >
> > Also, take note of the epoch in osdc output:
> >
> > 36      osd13   ... e327 ...
> >
> > Does "ceph osd dump" show the same epoch when things are stuck?
> >
>
> Unfortunately, the environment was gone.  But from the logs captured
> before, the epoch seems to be consistent between client and ceph
> cluster when thing are stuck, right?
>
> 2019-07-26 12:24:08.475 7f06efebc700  0 log_channel(cluster) log [DBG]
> : osdmap e306: 15 total, 15 up, 15 in
>
> BTW, logs of OSD.13 and dynamic debug kernel logs of libceph captured
> on the stuck node are provided in
> https://drive.google.com/drive/folders/1gYksDbCecisWtP05HEoSxevDK8sywKv6?usp=sharing.

The libceph log confirms that it had two laggy requests but it ends
before you restarted the OSD.  The OSD log is useless: we really need
to see individual ops coming in and replies going out.  It appears that
the OSD simply dropped those ops expecting the kernel to resend them
but that didn't happen for some reason.

Thanks,

                Ilya
