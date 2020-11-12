Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FCB2B028E
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Nov 2020 11:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbgKLKLB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Nov 2020 05:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgKLKLB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 12 Nov 2020 05:11:01 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33E7C0613D1
        for <ceph-devel@vger.kernel.org>; Thu, 12 Nov 2020 02:11:00 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id i18so3941209ioa.3
        for <ceph-devel@vger.kernel.org>; Thu, 12 Nov 2020 02:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aqmCQ0FWlnXZbl2sl7DHbNVUlBhruzqWE+eaYGPQkJQ=;
        b=n0xSt1siGcljbty8FkVgMGzxaEJbIZDjytZDdIxZWb7/Z3cgPeDv1d1HKCxzhhGebw
         KSWP3ZuX+vwBZ1wPjX2+QKeosdd466gX1m2BqMS+P/FxkhXoyhnsmSpCFLU/V8hkZAce
         Z5V2QEwnTqkX7aYC9d+HsvKE4Mh1CxRDtd5KzatIyGuu9s50aRoigsjeU6m73guxBs0t
         VO6vVAlGF91ggdQxElCAeP+Eo+Vd+p/EFQdPw2H4sI49tGWI0Dx+H3UW7lR/PmaFvvB3
         QR+XcFvCo9T1S52Gf229fomA3uSk1w1CxSOO/ufqCr1PlaWn+yq9f8r6T7iZXlvvrb9O
         tV2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aqmCQ0FWlnXZbl2sl7DHbNVUlBhruzqWE+eaYGPQkJQ=;
        b=LW538e1q7OnyooyG7Y+EFjeWkPWVOk1zuAfu7E0A2vodwqfVlcXEtmTA7LdoeggU+M
         1H7XR8HMm44EKNMqj71l/hAnkQHdm0RXRrIxxJziObT9g+Mzzp9ki+rLhH/moP/+iegv
         J4hl9WwmjdFS+UVTi/GxDmrvQ/J1QTro84r5Bi62LVU3DUhwAZ+83Tp5ejs0lQWE2Rch
         Wn5jkmSlX/T8f2or9fEmGo/5KsEOJOghxEVGDlJ9qBcGXXBaaNkQ07BZTiCnqEgrrkXc
         y5cP507N5TAO/e2uOPQva+8Hg2S3Mct99GwPSJ4eSK8nUecgKWSN/KnUHRhtWVE+Folb
         dgcg==
X-Gm-Message-State: AOAM533IAcyubUsfAR3Sn90tEt7gbLasL/iQgkfAnq7onP4BzDgsQpfC
        431iCJGuHOrO6yp43HFhD3h4TkqIIL0p0lnsxPA=
X-Google-Smtp-Source: ABdhPJwcmyDeCsZ4dofYcB3E9ZKpPOBgYiC4yKlVFv6ks3glx4zKxb4BStS86b1+RbJhkbfKVDWTNCEmwjZFisHGGBE=
X-Received: by 2002:a5e:8e01:: with SMTP id a1mr18281597ion.7.1605175860249;
 Thu, 12 Nov 2020 02:11:00 -0800 (PST)
MIME-Version: 1.0
References: <20201110141937.414301-1-xiubli@redhat.com> <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
 <CA+2bHPb1pP-xRGVrKfOqB8D94Nku_s5Kj+kVSzOzg3Zxpypzfg@mail.gmail.com> <08cde4b0-29b6-5846-56ab-df38268bba04@redhat.com>
In-Reply-To: <08cde4b0-29b6-5846-56ab-df38268bba04@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 12 Nov 2020 11:10:59 +0100
Message-ID: <CAOi1vP-SZ6zG_MATJDn15KAnO1-C-LFLw9_LgicX79UmiWUe7A@mail.gmail.com>
Subject: Re: [PATCH v3] libceph: add osd op counter metric support
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 12, 2020 at 3:30 AM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2020/11/11 23:18, Patrick Donnelly wrote:
> > On Tue, Nov 10, 2020 at 7:45 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> >> On Tue, Nov 10, 2020 at 3:19 PM <xiubli@redhat.com> wrote:
> >>> From: Xiubo Li <xiubli@redhat.com>
> >>>
> >>> The logic is the same with osdc/Objecter.cc in ceph in user space.
> >>>
> >>> URL: https://tracker.ceph.com/issues/48053
> >>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>> ---
> >>>
> >>> V3:
> >>> - typo fixing about oring the _WRITE
> >>>
> >>>   include/linux/ceph/osd_client.h |  9 ++++++
> >>>   net/ceph/debugfs.c              | 13 ++++++++
> >>>   net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++++++++++
> >>>   3 files changed, 78 insertions(+)
> >>>
> >>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> >>> index 83fa08a06507..24301513b186 100644
> >>> --- a/include/linux/ceph/osd_client.h
> >>> +++ b/include/linux/ceph/osd_client.h
> >>> @@ -339,6 +339,13 @@ struct ceph_osd_backoff {
> >>>          struct ceph_hobject_id *end;
> >>>   };
> >>>
> >>> +struct ceph_osd_metric {
> >>> +       struct percpu_counter op_ops;
> >>> +       struct percpu_counter op_rmw;
> >>> +       struct percpu_counter op_r;
> >>> +       struct percpu_counter op_w;
> >>> +};
> >> OK, so only reads and writes are really needed.  Why not expose them
> >> through the existing metrics framework in fs/ceph?  Wouldn't "fs top"
> >> want to display them?  Exposing latency information without exposing
> >> overall counts seems rather weird to me anyway.
> > `fs top` may want to eventually display this information but the
> > intention was to have a "perf dump"-like debugfs file that has
> > information about the number of osd op reads/writes. We need that for
> > this test:
> >
> > https://github.com/ceph/ceph/blob/master/qa/tasks/cephfs/test_readahead.py#L20
> >
> > Pulling the information out through `fs top` is not a direction I'd like to go.
> >
> >> The fundamental problem is that debugfs output format is not stable.
> >> The tracker mentions test_readahead -- updating some teuthology test
> >> cases from time to time is not a big deal, but if a user facing tool
> >> such as "fs top" starts relying on these, it would be bad.
> > `fs top` will not rely on debugfs files.
> >
> There has one bug in the "test_readahead.py", I have fixed it in [1]. I
> think the existing cephfs metric framework is far enough for us to
> support the readahead qa test for kclient.
>
> [1] https://github.com/ceph/ceph/pull/38016

Yeah, it already provides a debugfs file, so the test wouldn't need
"fs top" to pull that counter out.

Thanks,

                Ilya
