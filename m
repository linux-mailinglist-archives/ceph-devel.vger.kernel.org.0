Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36DA518BE2
	for <lists+ceph-devel@lfdr.de>; Thu,  9 May 2019 16:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfEIOeV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 May 2019 10:34:21 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:53633 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfEIOeV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 May 2019 10:34:21 -0400
Received: by mail-it1-f194.google.com with SMTP id m141so2548207ita.3;
        Thu, 09 May 2019 07:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VgJt5C+991VNWAo5dCRQvyOkHnEHtESv8VIdObcT0PI=;
        b=CLO0tKp52jc09CGApkaqy0ttB00N6E8fRkAynf0w5YJpWui2iq+Hx8w+ZKstX/d2IK
         0TeE53wr8mdCT6zC2e7H1ZhCzS26Ktav0ER5+IP6nuLS7rqz2QXapCSDXCvujALvQBlK
         xC1DRd4f0iJNEcOT08vILW779G9aoxalkiviYPpuqjV3N0sQJBV0gXpdZ7xE3ke4YqmY
         D0Tdf2iIqoQtZCV+aWlWUv54j1F7A6RlZl9hX7wPDQcwXC8QZEG2mSPsgdmI29vu+vBW
         AYGEsCITd+bGeOg8aweURo3T6TpJHw5ZYUV24WxQliRINPBrLOaiXUvuQA4bZFi+BB0m
         0DCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VgJt5C+991VNWAo5dCRQvyOkHnEHtESv8VIdObcT0PI=;
        b=OFtKqR0sZg9/MKBDIPTFk8OdWGFGO1MkGL+il4Zy0E+oyXdV4xZZR2wA/o3AJoWGX9
         k7BZYuQPy3xzrSFQw84PnZt3vA2Bc35VqRIAqs9dr30utYWINWHMLwBOF6h9RxQM5DBS
         BRWYuoq/vMDwdZeXNMOLybwXtl3T7IHN29ogwHHHU7675fQt9PgAovPbTXj05wf1xjQz
         XSVPK2bEKcH9GxMHTzV0uWGUJ/1JOUG8d3gxB7c3lwB3JhSJAFrS2K5hioG2Wl1/GRJ1
         19yKjDOatjEUGPD/09pUBbA15lW5KvPxlPfIcHrHsWXMx40hAZ9HcKuJOH9lUFHL53ID
         y6nA==
X-Gm-Message-State: APjAAAWHuN7OChNxKlXWrc5wrOnRHmhycojoXVio1jq5Wk/B9AWNr1F2
        ubX/BVhPZZVS5vmdwqAex9SNecpHDeedikfkk2g=
X-Google-Smtp-Source: APXvYqyYR9t9z/joKnL30Jv42mD17GPbqxqjTtM/E1dmegmuMaJMhzeBJ+J4ODyY7D+sp1IaXJ8I8XJFgVZQnJeDvos=
X-Received: by 2002:a02:741c:: with SMTP id o28mr3352801jac.144.1557412460759;
 Thu, 09 May 2019 07:34:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190509101125.GC7024@mwanda>
In-Reply-To: <20190509101125.GC7024@mwanda>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 9 May 2019 16:34:30 +0200
Message-ID: <CAOi1vP-sv2wT3zK+odQLY1tvksK6k8DOZZ5W04zFCsVajwraiw@mail.gmail.com>
Subject: Re: [PATCH] ceph: Silence a checker warning on the error path
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 9, 2019 at 12:11 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The problem is that if ceph_mdsc_build_path() fails then we set "path"
> to NULL and the "pathlen" variable is uninitialized.  The we call
> ceph_mdsc_free_path(path, pathlen) to clean up.  Since "path" is NULL,
> the function is a no-op but Smatch and UBSan still complain that
> "pathlen" is uninitialized.
>
> This patch doesn't change run time, it just silence the warnings.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/ceph/debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index b3fc5fe26a1a..a14d64664878 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -52,7 +52,7 @@ static int mdsc_show(struct seq_file *s, void *p)
>         struct ceph_mds_client *mdsc = fsc->mdsc;
>         struct ceph_mds_request *req;
>         struct rb_node *rp;
> -       int pathlen;
> +       int pathlen = 0;
>         u64 pathbase;
>         char *path;
>

Applied.

Thanks,

                Ilya
