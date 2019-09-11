Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FE4B03AF
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 20:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfIKScf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 14:32:35 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36387 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729825AbfIKScf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Sep 2019 14:32:35 -0400
Received: by mail-io1-f68.google.com with SMTP id b136so48219917iof.3
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2019 11:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yTUKwfQ1M5s88Dxgsklac6B+3MRh6p9URMByF6Dab24=;
        b=X/xy6Ze+XQGy4VJ4Xl02BC9aPlfPXD8sb/ovHF+Ko10nqMKMQzPTvpGS7UTsjxpHGR
         9LLh7uBhch4xwO4bhucjmu6s/C54yLUy6rIOxdj9BUP0Aq3pnaq0X8aCIJdLm5coLTT9
         wqNVK7JKuxNy45XLS5mi5lsq4yLE68V1lCp7EfQVBZdswQ7lwSIjlXXJUNJyyRdnxMvj
         E4TpKgQdEjw4Snmq/w0tmXav4nZWKdu4+LFB694dnS8ps6ZmipB3ggl4DcuaaZO+Trmv
         Yd+qBG0SNvzRJ1aktRdALdDVVC7NiRw2JGmHEXG+YJRUbGPTZzfGkNvXEqTggw6TOw4M
         3HyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yTUKwfQ1M5s88Dxgsklac6B+3MRh6p9URMByF6Dab24=;
        b=GGGQfcfKqSKFDbYMwvAyTgW/7db1k6Wjz+JM27fckEzMp5QHQxAX4HVh27CJgsAQD8
         lyvNFOp7ez/K/8njNpHibK3Ah4IBTwBxCc6MX92iUz7IIJsRrxx65keWDmWIYGI47F2/
         Le2zuRcUKnutFQxJBtgd8ZarholvJdJgufrtxn+q+lb9Fn59jnTHCQHswtOvMuFJW6Ar
         YUrkfBObCklOaVrfjxPiOAPFCew1AL5UgUbTEY30R8aOlvShltqxfExEQSLmIyNBg8Th
         elWICHZJizuvkm90Wu4/j5/Bxu35J2fR5L58c4ysG4JnSXgkAnMyb5g9tLZMdAyOOcXS
         N4vA==
X-Gm-Message-State: APjAAAUyC8czmGOi2BHcHlPKOctbxUr0nOKKasyvuBx2biAX/pjK6wwM
        MKV90hlFnHF3yKpPWRY64IPVBKLolPv3DkKU020=
X-Google-Smtp-Source: APXvYqzlQVd1lSm7ygD9eIoo5x/OGvpkScppR2cIaLXZXV2x3ndwgi6lPkqC9BvxV9DjTQxBNdFihuO90HrV/+cN8ok=
X-Received: by 2002:a6b:ef0b:: with SMTP id k11mr8547565ioh.143.1568226752726;
 Wed, 11 Sep 2019 11:32:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190911164037.23495-1-jlayton@kernel.org>
In-Reply-To: <20190911164037.23495-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 11 Sep 2019 20:32:26 +0200
Message-ID: <CAOi1vP-=qNbaCffVft8WDUuHvS9BccML8zvC8ZszDb=QGb6LVg@mail.gmail.com>
Subject: Re: [PATCH] ceph: convert int fields in ceph_mount_options to
 unsigned int
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 11, 2019 at 6:42 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Most of these values should never be negative, so convert them to
> unsigned values. Leave caps_max alone however, as it will be compared
> with a counter that we want to leave signed.
>
> Add some sanity checking to the parsed values, and clean up some
> unneeded casts.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c |  5 +++--
>  fs/ceph/super.c      | 34 ++++++++++++++++++----------------
>  fs/ceph/super.h      | 16 ++++++++--------
>  3 files changed, 29 insertions(+), 26 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 0d7afabb1f49..da882217d04d 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2031,12 +2031,13 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>         struct ceph_mds_reply_info_parsed *rinfo = &req->r_reply_info;
>         struct ceph_mount_options *opt = req->r_mdsc->fsc->mount_options;
>         size_t size = sizeof(struct ceph_mds_reply_dir_entry);
> -       int order, num_entries;
> +       unsigned int num_entries;
> +       int order;
>
>         spin_lock(&ci->i_ceph_lock);
>         num_entries = ci->i_files + ci->i_subdirs;
>         spin_unlock(&ci->i_ceph_lock);
> -       num_entries = max(num_entries, 1);
> +       num_entries = max(num_entries, 1U);
>         num_entries = min(num_entries, opt->max_readdir);
>
>         order = get_order(size * num_entries);
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 2710f9a4a372..fa95c2faf167 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -170,10 +170,10 @@ static const struct fs_parameter_enum ceph_param_enums[] = {
>  static const struct fs_parameter_spec ceph_param_specs[] = {
>         fsparam_flag_no ("acl",                         Opt_acl),
>         fsparam_flag_no ("asyncreaddir",                Opt_asyncreaddir),
> -       fsparam_u32     ("caps_max",                    Opt_caps_max),
> +       fsparam_s32     ("caps_max",                    Opt_caps_max),
>         fsparam_u32     ("caps_wanted_delay_max",       Opt_caps_wanted_delay_max),
>         fsparam_u32     ("caps_wanted_delay_min",       Opt_caps_wanted_delay_min),
> -       fsparam_s32     ("write_congestion_kb",         Opt_congestion_kb),
> +       fsparam_u32     ("write_congestion_kb",         Opt_congestion_kb),
>         fsparam_flag_no ("copyfrom",                    Opt_copyfrom),
>         fsparam_flag_no ("dcache",                      Opt_dcache),
>         fsparam_flag_no ("dirstat",                     Opt_dirstat),
> @@ -185,8 +185,8 @@ static const struct fs_parameter_spec ceph_param_specs[] = {
>         fsparam_flag_no ("quotadf",                     Opt_quotadf),
>         fsparam_u32     ("rasize",                      Opt_rasize),
>         fsparam_flag_no ("rbytes",                      Opt_rbytes),
> -       fsparam_s32     ("readdir_max_bytes",           Opt_readdir_max_bytes),
> -       fsparam_s32     ("readdir_max_entries",         Opt_readdir_max_entries),
> +       fsparam_u32     ("readdir_max_bytes",           Opt_readdir_max_bytes),
> +       fsparam_u32     ("readdir_max_entries",         Opt_readdir_max_entries),
>
> [...]
>
>         case Opt_caps_max:
> -               fsopt->caps_max = result.uint_32;
> +               if (result.int_32 < 0)
> +                       goto invalid_value;
> +               fsopt->caps_max = result.int_32;

I picked on David's patch because it converted everything to unsigned,
but left write_congestion_kb, readdir_max_bytes and readdir_max_entries
signed.  None of them can be negative, so it didn't make sense to me.

This patch fixes that, but leaves caps_max signed.  caps_max can't be
negative, so again it doesn't make sense to me.  If we are going to
tweak the option table as part of this conversion, I think it needs to
be consistent: either signed with a check or unsigned without a check
for all options that can't be negative.

Thanks,

                Ilya
