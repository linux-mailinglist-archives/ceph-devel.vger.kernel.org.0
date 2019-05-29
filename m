Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86242E542
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 21:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfE2T1r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 15:27:47 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:46805 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfE2T1q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 15:27:46 -0400
Received: by mail-pg1-f176.google.com with SMTP id v9so450994pgr.13
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 12:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GgQ+yLKIHYfJY4DRpVex1xXdpbEh+Kao6MvOeZtwBbA=;
        b=bvUlV55/+Glu4f/PgcObQs8jhkIT+0cUqIWzdxTdrcExDcBkXjeVH9NZr1fp6efa7r
         4AsJ+XrZacn9yqj7XjY1kyfutIWyII039CtzTEZMMXdq2swH6mdg1JfPqTgEGerGIpPc
         NEo3qOc1hjSOiQLqGwrXoeoyO20YTHvU1s3JbHOU1ao6TJScAvY2obhZ8k4IWBomauDm
         Q92bucAzA0ySu7u2DKWNgUMtEGhMIQXbulyn/6fFsV27HjTmyj6aJ4w0zsDR7xLvKePc
         hX2mSt4PUdXGkk2g0hUyr5JfuG5/6l5vSSOItTZ0EwR1MxHNCJGJYhbhCXk4PUhPYE7G
         Ac8Q==
X-Gm-Message-State: APjAAAUyWbbnR1toJvxue398FO75250ApuRYELeWPQrvfO/G7g0Zi18T
        j84Z/9zVLwRv5Jwpv2GyhVJ31rqygNyoiBvB+Cn65Q==
X-Google-Smtp-Source: APXvYqwRxZFMMOAlTxACIu90qlHHjLxnCmGRZFGdABVqiuDKNtW2eiPcQhxBxBJhUWmLJgMLt12R9OzV7RcGMT4AG20=
X-Received: by 2002:a17:90a:cb10:: with SMTP id z16mr14012912pjt.81.1559158064890;
 Wed, 29 May 2019 12:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
 <CAC-Np1wR4ik58P=UPLuuBxhqbG_REx1UFp4mDPNdBiNQFW9W_g@mail.gmail.com>
In-Reply-To: <CAC-Np1wR4ik58P=UPLuuBxhqbG_REx1UFp4mDPNdBiNQFW9W_g@mail.gmail.com>
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Wed, 29 May 2019 12:27:33 -0700
Message-ID: <CAMMFjmGro96-bhMOe2KGYjZLAu-6RrNKAvOom+wP3ovg_+ss7Q@mail.gmail.com>
Subject: Re: 13.2.6 QE Mimic validation status
To:     Alfredo Deza <adeza@redhat.com>
Cc:     Sage Weil <sweil@redhat.com>, "Durgin, Josh" <jdurgin@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        Andrew Schoen <aschoen@redhat.com>, ceph-qa <ceph-qa@ceph.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Sebastien Han <shan@redhat.com>,
        Brad Hubbard <bhubbard@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Neha Ojha <nojha@redhat.com>,
        David Galloway <dgallowa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

See missing approvals http://tracker.ceph.com/issues/39718#note-2

Venky, Patrick FYI seeking approvals for fs, mulltimds and kcephfs

Josh, pls approve rados.
upgrade/mimic-p2p - tests being fixed
https://github.com/ceph/ceph/pull/28301, Josh was helping to
troubleshoot

(Ilya, missing question mask was my typo, sorry for confusion)

Thx
YuriW

On Wed, May 29, 2019 at 5:16 AM Alfredo Deza <adeza@redhat.com> wrote:
>
> On Thu, May 23, 2019 at 4:00 PM Yuri Weinstein <yweinste@redhat.com> wrote:
> >
> > Details of this release summarized here:
> >
> > http://tracker.ceph.com/issues/39718#note-2
> >
> > rados - FAILED, known, Neha approved?
> > rgw - Casey approved?
> > rbd - Jason approved?
> > fs - Patrick, Venky approved?
> > kcephfs - Patrick, Venky approved?
> > multimds - Patrick, Venky approved? (still running)
> > krbd - Ilya, Jason approved?
> > ceph-deploy - Sage, Vasu approved?  See SELinux denials, David pls FYI
> > ceph-disk - PASSED
> > upgrade/client-upgrade-jewel - PASSED
> > upgrade/client-upgrade-luminous - PASSED
> > upgrade/luminous-x (mimic) - PASSED
> > upgrade/mimic-p2p - tests needs fixing
> > powercycle - PASSED, Neha FYI
> > ceph-ansible - PASSED
> > ceph-volume - FAILED, Alfredo pls rerun
>
> APPROVED. The failures are due to a configuration error, all nightly
> mimic runs are passing. Filed http://tracker.ceph.com/issues/40062 to
> fix the config problem.
>
> >
> > Please review results and reply/comment.
> >
> > PS:  Abhishek, Nathan I will back in the office next Tuesday.
> >
> > Thx
> > YuriW
