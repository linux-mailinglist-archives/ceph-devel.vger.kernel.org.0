Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2581E86E0
	for <lists+ceph-devel@lfdr.de>; Fri, 29 May 2020 20:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgE2Smp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 14:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgE2Smp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 May 2020 14:42:45 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1D9C03E969
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 11:42:45 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id 9so3429686ilg.12
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 11:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pwgb8uNX/Hf5YAASo6wu0Y8Wf4KFKcjFNxtELrPS9WU=;
        b=CqBkQNpu8oYUrKVe3g6L7LxlcMb3AHeSiHDNvjENtQbKD480v0XcbrF0Kcm7jpEURt
         a4t257TDgTHz/Ooze1dxPZBc3Ot69mb/rnM5GVR3kz4Q96fuToX7UEmZOvIUo1WfJc/3
         Gg5sdlVrfNcX8g7MPYJTJ0qA8l5fNqJlIMedjTe5D1h9M+zky1YXE7i+KpCne9nbXmhj
         RGjZ9SmFPXRvFV3Ff20O37TNK0ogYpFQOGL+CP6Q70l/GMPlJkKtCMGDSHT1REcRVuyC
         mX2IbAPKF6WLB5MoRwaerxUAbkql0zIwS68uokD+Pu4PyNwnRQuNYHS5FBowYMb0U5Ym
         sUCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pwgb8uNX/Hf5YAASo6wu0Y8Wf4KFKcjFNxtELrPS9WU=;
        b=JtdtyusIsg/9tNgzqoEk8EP8b1V3akT806azwzHY/PTHvj4JjcNzAqIDv2mGapMW1o
         od2NfnxoDULYH9FxQUQy37lVV5Hk1px78T/x0YjGaX2GbZYkbl2mN/Rc/wXclxbZDcE1
         k996zPmKBymYxi2mducR2mIK8oxu43uAELIrdTCEhs0pUUJXOP668WbVbEfdykIAvZwi
         qXF1lPUPIGgtNtriEZAw9PDfRvNdILP/1uCmefEHqHOS89hf69me+fRS+Nk/kNeMRm5B
         u7WWXy90q6ijN3+km6aCQG1qpougqnax2cuIWuKTfE23VIuHdnRdls/87a/Y3vQE73+A
         YLHw==
X-Gm-Message-State: AOAM530WNud+oNwbE8tePf2JJydU54jUP4I2sZ3llFSgfL4GH/LoU50B
        q/wstr9ISCfHKF84JzPUFhDsv7Lfuiv/EOKV9Jo=
X-Google-Smtp-Source: ABdhPJzzr1yqN55B2Z8bVrdyfK2kXlBnhsN29fquD/hQIGq6q7D8qmvXZDwacqrzAkOzlD+/KQQRwR6vPqTVKWFKlxA=
X-Received: by 2002:a92:9c89:: with SMTP id x9mr9296624ill.112.1590777764513;
 Fri, 29 May 2020 11:42:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200529151952.15184-1-idryomov@gmail.com> <20200529151952.15184-6-idryomov@gmail.com>
 <fbbfce8d4f9d12916c63f68573af500db7840958.camel@kernel.org>
In-Reply-To: <fbbfce8d4f9d12916c63f68573af500db7840958.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 29 May 2020 20:42:49 +0200
Message-ID: <CAOi1vP_B=zuyhxjCroC4M68e5_0jHtTMJYiqVEQNNnfuWQVC5w@mail.gmail.com>
Subject: Re: [PATCH 5/5] libceph: read_policy option
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 29, 2020 at 7:19 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-05-29 at 17:19 +0200, Ilya Dryomov wrote:
> > Expose balanced and localized reads through read_policy=balance
> > and read_policy=localize.  The default is to read from primary.
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  include/linux/ceph/libceph.h |  2 ++
> >  net/ceph/ceph_common.c       | 26 ++++++++++++++++++++++++++
> >  net/ceph/osd_client.c        |  5 ++++-
> >  3 files changed, 32 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> > index 4733959f1ec7..0a9f807ceda6 100644
> > --- a/include/linux/ceph/libceph.h
> > +++ b/include/linux/ceph/libceph.h
> > @@ -52,6 +52,8 @@ struct ceph_options {
> >       unsigned long osd_idle_ttl;             /* jiffies */
> >       unsigned long osd_keepalive_timeout;    /* jiffies */
> >       unsigned long osd_request_timeout;      /* jiffies */
> > +     unsigned int osd_req_flags;  /* CEPH_OSD_FLAG_*, applied to
> > +                                     each OSD request */
> >
> >       /*
> >        * any type that can't be simply compared or doesn't need
> > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > index 6d495685ee03..1a834cb0d04d 100644
> > --- a/net/ceph/ceph_common.c
> > +++ b/net/ceph/ceph_common.c
> > @@ -265,6 +265,7 @@ enum {
> >       Opt_key,
> >       Opt_ip,
> >       Opt_crush_location,
> > +     Opt_read_policy,
> >       /* string args above */
> >       Opt_share,
> >       Opt_crc,
> > @@ -274,6 +275,17 @@ enum {
> >       Opt_abort_on_full,
> >  };
> >
> > +enum {
> > +     Opt_read_policy_balance,
> > +     Opt_read_policy_localize,
> > +};
> > +
> > +static const struct constant_table ceph_param_read_policy[] = {
> > +     {"balance",     Opt_read_policy_balance},
> > +     {"localize",    Opt_read_policy_localize},
> > +     {}
> > +};
> > +
> >  static const struct fs_parameter_spec ceph_parameters[] = {
> >       fsparam_flag    ("abort_on_full",               Opt_abort_on_full),
> >       fsparam_flag_no ("cephx_require_signatures",    Opt_cephx_require_signatures),
> > @@ -290,6 +302,8 @@ static const struct fs_parameter_spec ceph_parameters[] = {
> >       fsparam_u32     ("osdkeepalive",                Opt_osdkeepalivetimeout),
> >       __fsparam       (fs_param_is_s32, "osdtimeout", Opt_osdtimeout,
> >                        fs_param_deprecated, NULL),
> > +     fsparam_enum    ("read_policy",                 Opt_read_policy,
> > +                      ceph_param_read_policy),
> >       fsparam_string  ("secret",                      Opt_secret),
> >       fsparam_flag_no ("share",                       Opt_share),
> >       fsparam_flag_no ("tcp_nodelay",                 Opt_tcp_nodelay),
> > @@ -470,6 +484,18 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
> >                       return err;
> >               }
> >               break;
> > +     case Opt_read_policy:
> > +             switch (result.uint_32) {
> > +             case Opt_read_policy_balance:
> > +                     opt->osd_req_flags |= CEPH_OSD_FLAG_BALANCE_READS;
> > +                     break;
> > +             case Opt_read_policy_localize:
> > +                     opt->osd_req_flags |= CEPH_OSD_FLAG_LOCALIZE_READS;
> > +                     break;
> > +             default:
> > +                     BUG();
> > +             }
> > +             break;
>
> Suppose I specify "-o read_policy=balance,read_policy=localize".
>
> Principle of least surprise says "last one wins", but you'll end up with
> both flags set here, and I think the final result would still be
> "balance". I think it'd probably be best to rework this so that the last
> option specified is what you get.
>
> I also think you want a way to explicitly set it back to default
> behavior (read_policy=primary ?), as it's not uncommon for people to
> specify mount options in fstab but then append to them on the command
> line. e.g.:
>
>     # mount /mnt/cephfs -o read_policy=primary
>
> ...when fstab already has read_policy=balance.

Yes, currently balance wins.

Adding read_policy=primary and implementing the override behaviour
for read_policy sounds reasonable.

Thanks,

                Ilya
