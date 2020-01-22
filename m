Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59CE0144C67
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jan 2020 08:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgAVHUg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jan 2020 02:20:36 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45838 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVHUf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Jan 2020 02:20:35 -0500
Received: by mail-qv1-f68.google.com with SMTP id l14so2762016qvu.12
        for <ceph-devel@vger.kernel.org>; Tue, 21 Jan 2020 23:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pwlj2VFyCsHXaFqkmqFSrMOgF8zqgwTSOGcaxpEYHR8=;
        b=uGpFzfmj9WckmLJPSr+/KnsJIM6OYK4GgqsocSYiNLpbIhWOlFZJ3vsqU6VGoJRU/x
         VQJLcrP2eIZAIlCjpSmn0KQmra73dA6Gnlhzq8aSuyFHcn6ZqPvO5tSwI3f3ut6UdAPz
         b/wAq5F2bRc/3yawIdUXE3lOA/XuIaBSvC+AMdKdra8aABx8wcMRVVTW3jhlwaAbBbk9
         mq+Zy5pdOj1EtT/XlCfh8++DIbR2mEDVmV3gqYMUEp9Xi/8A6Ug/mXhThrXgvT2ZFZOX
         +nIvu+1kB+qNy22tc78h6ITLcHqXKvctdij+4KuhWG37Y5JFC1xHGITOxJDsMEy8dhNC
         e8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pwlj2VFyCsHXaFqkmqFSrMOgF8zqgwTSOGcaxpEYHR8=;
        b=pdAIq4KAoRW1bbfL4UO/00Ytxi1XLFL5a/O1az2WA+ttYeq4nuGqp0t15ugyh9bHn6
         bMgs5HEb7aues57NjSVchL91JFG4dhhgEJAJ2UgMnIjRJUAQ2O306jw63xR7ivMrzBSW
         O6z7kT5/wyt3+fGJs46KsIawhHSqliDxuR9Nohl6YLfdPmg2TVrJr5yYEahV/cIWbZ3a
         X63fsJ9GrJQz3QHvQdd/haoOZplEzT/gkyp954mEQD394cvr1+b8vGVnt4p5/BYp+AtF
         MLH8MpRQyb/AZpUF91oa3ZV8KuxbYW41l6LvwqdFlIfeLiOY11U/Lfm39nxC85vMp/3b
         rxcw==
X-Gm-Message-State: APjAAAWyfYJMCbaYhuIr5kNa0cTseoJsyqGWyzPKf8UUVMogkziu9J1N
        R2h5SEF3GR0P5y7rmE9E0OOVoE8ItuJDTtFhzpY=
X-Google-Smtp-Source: APXvYqziLkbblQzH9qTkR+yIQS0XJeNEZjoVs/6/yYhTq6MhuOahwGrBH1yS8QO8ecbs8uVwxlecNUVQy8g/l/jxdVI=
X-Received: by 2002:a0c:9023:: with SMTP id o32mr9100958qvo.110.1579677634735;
 Tue, 21 Jan 2020 23:20:34 -0800 (PST)
MIME-Version: 1.0
References: <20200121192928.469316-1-jlayton@kernel.org> <20200121192928.469316-4-jlayton@kernel.org>
In-Reply-To: <20200121192928.469316-4-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 22 Jan 2020 15:20:23 +0800
Message-ID: <CAAM7YAkL2fOgmxSatHreHjveZmzXd9o3ZsfhCW4C18x1He0eAg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/10] ceph: make dentry_lease_is_valid non-static
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>, Zheng Yan <zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 22, 2020 at 3:31 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> ...and move a comment over the proper function.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/dir.c   | 10 +++++-----
>  fs/ceph/super.h |  1 +
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 10294f07f5f0..9d2eca67985a 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1477,10 +1477,6 @@ void ceph_invalidate_dentry_lease(struct dentry *dentry)
>         spin_unlock(&dentry->d_lock);
>  }
>
> -/*
> - * Check if dentry lease is valid.  If not, delete the lease.  Try to
> - * renew if the least is more than half up.
> - */
>  static bool __dentry_lease_is_valid(struct ceph_dentry_info *di)
>  {
>         struct ceph_mds_session *session;
> @@ -1507,7 +1503,11 @@ static bool __dentry_lease_is_valid(struct ceph_dentry_info *di)
>         return false;
>  }
>
> -static int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags)
> +/*
> + * Check if dentry lease is valid.  If not, delete the lease.  Try to
> + * renew if the least is more than half up.
> + */
> +int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags)
>  {
>         struct ceph_dentry_info *di;
>         struct ceph_mds_session *session = NULL;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ec4d66d7c261..f27b2bf9a3f5 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1121,6 +1121,7 @@ extern int ceph_handle_snapdir(struct ceph_mds_request *req,
>  extern struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
>                                          struct dentry *dentry, int err);
>
> +extern int dentry_lease_is_valid(struct dentry *dentry, unsigned int flags);
>  extern void __ceph_dentry_lease_touch(struct ceph_dentry_info *di);
>  extern void __ceph_dentry_dir_lease_touch(struct ceph_dentry_info *di);
>  extern void ceph_invalidate_dentry_lease(struct dentry *dentry);
> --
> 2.24.1
>

This change is not needed
