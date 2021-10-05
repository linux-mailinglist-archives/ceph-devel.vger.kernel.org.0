Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B70422010
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Oct 2021 10:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhJEIF0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 5 Oct 2021 04:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhJEIDP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 5 Oct 2021 04:03:15 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24461C061745
        for <ceph-devel@vger.kernel.org>; Tue,  5 Oct 2021 01:01:09 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id y28so8838467vsd.3
        for <ceph-devel@vger.kernel.org>; Tue, 05 Oct 2021 01:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O9ql0BZkN2CmiZTSTJAblWux1k4NlPXl+R3h2gU2pXI=;
        b=JykTyBmyfQBIAoq83lOFnQyauiALlTua9tPJbBdN1Atl4L9qlwfC5B+wi29SwFJg6D
         QIXAu6b6i9pNxqcn2fPyUbNV+rdnlMLmwDFnRWzOx8k535dfVAKioOSlImpbHFj46dAM
         zm30yR6vhjCfzuAvixJWW7SoQ7ehoejlPvuH0sDopkfJGoZYdnD1TKTHpwwvoj70TKFz
         UJfvgciGwQBSDTxcXfW+2ReKlavSos253PdIF5LOWnRF9OQWYqluUao15BnYYu8BTq1A
         ILKi3NQZmVL+c9wzpSzexmU4naUDRkivaMVpy6v3Q4eak1ihOCy2j9ssCmO/Xu3EYBnx
         E1mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O9ql0BZkN2CmiZTSTJAblWux1k4NlPXl+R3h2gU2pXI=;
        b=PCS3OdLM4Isp3rdkSBYUIHk/rvEJUazQ2Z0qJ97y3HcDKyYDuBfxHHKJB3XnF056Oe
         TQ+YzQ/bcnLEMPe6m2NPDydaBZvxfbGdO9t6IbzbhgQjR2oWq8tRFY83omk1ImbCXIPH
         C7a8kMT823l3M8MnM8SKwVtIvQ6PiPAewyWdbNGc49Dakzubn03gXFb30qa9mhY7iB2L
         5YBpg1LQ1jrpSlUriym3eXh3VqzihO9vFkJJNyhlGs17427WAd/sa0H0emQyD8TS+v54
         9nhDfwtC6DnJmmL3VLD+vMM8TodrrHgLoLG/O3RMvEEFvfTPJZIyDZe9BvfeB2SCIIvi
         Y2CQ==
X-Gm-Message-State: AOAM532RodGs9DJzARp7bDChGxSSpjIANO6FNe6tc/BXMNgbrLD1TKfI
        9aw6efCQu92UrSPhsRAg8t5OlaoM85KUkB870fs=
X-Google-Smtp-Source: ABdhPJydTMTk+oaPXqaAn/3zvQSSLy+wSacVg25BgTCISL9acu+W01/1PIGjtYiW1Za5GFAck4OJvUDi9f9r/M/pm4g=
X-Received: by 2002:a67:c107:: with SMTP id d7mr10982419vsj.44.1633420868328;
 Tue, 05 Oct 2021 01:01:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210930170302.74924-1-jlayton@kernel.org>
In-Reply-To: <20210930170302.74924-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 5 Oct 2021 10:00:37 +0200
Message-ID: <CAOi1vP9YBcxMAMe1yE4v-E6gmK0GbYMKX5yODAYQOXvRd39FFg@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: skip existing superblocks that are blocklisted
 when mounting
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Niels de Vos <ndevos@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Sep 30, 2021 at 7:03 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Currently when mounting, we may end up finding an existing superblock
> that corresponds to a blocklisted MDS client. This means that the new
> mount ends up being unusable.
>
> If we've found an existing superblock with a client that is already
> blocklisted, and the client is not configured to recover on its own,
> fail the match.
>
> While we're in here, also rename "other" to the more conventional "fsc".
>
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Cc: Niels de Vos <ndevos@redhat.com>
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=1901499
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/super.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index f517ad9eeb26..a7f1b66a91a7 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1123,16 +1123,16 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
>         struct ceph_fs_client *new = fc->s_fs_info;
>         struct ceph_mount_options *fsopt = new->mount_options;
>         struct ceph_options *opt = new->client->options;
> -       struct ceph_fs_client *other = ceph_sb_to_client(sb);
> +       struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
>
>         dout("ceph_compare_super %p\n", sb);
>
> -       if (compare_mount_options(fsopt, opt, other)) {
> +       if (compare_mount_options(fsopt, opt, fsc)) {
>                 dout("monitor(s)/mount options don't match\n");
>                 return 0;
>         }
>         if ((opt->flags & CEPH_OPT_FSID) &&
> -           ceph_fsid_compare(&opt->fsid, &other->client->fsid)) {
> +           ceph_fsid_compare(&opt->fsid, &fsc->client->fsid)) {
>                 dout("fsid doesn't match\n");
>                 return 0;
>         }
> @@ -1140,6 +1140,11 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
>                 dout("flags differ\n");
>                 return 0;
>         }
> +       /* Exclude any blocklisted superblocks */
> +       if (fsc->blocklisted && !(fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)) {

Hi Jeff,

Nit: This looks a bit weird because fsc is the existing client while
fsopt is the new set of mount options.  They are guaranteed to match at
that point because of compare_mount_options() but it feels better to
stick to probing the existing client, e.g.

   if (fsc->blocklisted && !ceph_test_mount_opt(fsc, CLEANRECOVER))

Thanks,

                Ilya
