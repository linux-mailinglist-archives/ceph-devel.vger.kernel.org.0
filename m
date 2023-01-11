Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB08D665B41
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Jan 2023 13:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbjAKMWe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Jan 2023 07:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjAKMWb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Jan 2023 07:22:31 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7206376
        for <ceph-devel@vger.kernel.org>; Wed, 11 Jan 2023 04:22:30 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ss4so29092856ejb.11
        for <ceph-devel@vger.kernel.org>; Wed, 11 Jan 2023 04:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vHs+xfBpw8G50AmdRjkElwih5ZsuoIcNMu6T4tZ/+Kw=;
        b=kaPDQKawJt1RS0z2C6FBqKEhpqKnZdpAQL/qwHTkFKa6W7szA+o1fgyVXeaqrKv1Km
         feXaHlmm/576gXwt2pn01gYlHGL4gKvumGNYY7bXh+9LzFwTTY+RQbHvTU6zowKcf35F
         MHAW3bxblvdd+VmpgkBE9r16GY4bDrR7BvWbuRXdMQqrSNCfU81m+x7tZvBfYGlUFId2
         YYvL75vkJTofNko0vhOTz3BqJcu2lRFmH1xnZVEfIR+3DhMxi3vwvHjU004C6k/WJGap
         52sYZVaXhkqorgifKmEfQ4JWB0QJqzLvsafuGLoIBFr6RjyFk2wFSxL8Foild2PzC/QW
         oRuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vHs+xfBpw8G50AmdRjkElwih5ZsuoIcNMu6T4tZ/+Kw=;
        b=zBI0VJ0zE7T83rDkmfLWfMxEpGUmZXQ1IbgA0hadbOUNUfsT4ipXYRGv8rkMzVFqoi
         ISud6JMm6UxNyuAhlwysVUtmT6YOMpOJQmZhVAKa3b3grMqn1+vkQkhaiSkeOzHRNHAU
         4gpbxcZfphVBpLNZ8vAI+ewKXXXGWUGdYrqaHqcnMb87rX08FD8crIYJ9PO5MNBPVk2G
         vFKVBnsSlsVqrC4O5irJBxa3oti8Q0W6f32Uwug6xMg5gHxpG7mf+MNW3Qhvio9TIZ+Q
         1VKceV9ORmWozYPaeH8Z9GL3xSYOOGcU6CLsFHa+qMAQcKGT5wFJhE0GWdA0eW3NKW8/
         q3/w==
X-Gm-Message-State: AFqh2kqWJc5gkjfL1pWXyFOuwwNu0txHYEO6y7CDo02TENTLPOZlxxJ/
        wSNKTr4iA1da7zjqZmVZPQy9467M8XGlcV4A5OA=
X-Google-Smtp-Source: AMrXdXvK26RFSvptfJj9tAIrl/S2s5ZYWqCv7nzfYmqweU2XoOxft5HEJpSHWOf9YTppa+PgeS/JPv/tH6uE7q6xnk4=
X-Received: by 2002:a17:906:708f:b0:7c4:e857:e0b8 with SMTP id
 b15-20020a170906708f00b007c4e857e0b8mr5187783ejk.603.1673439749471; Wed, 11
 Jan 2023 04:22:29 -0800 (PST)
MIME-Version: 1.0
References: <20230111011403.570964-1-xiubli@redhat.com>
In-Reply-To: <20230111011403.570964-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 11 Jan 2023 13:22:17 +0100
Message-ID: <CAOi1vP-Q48xUJNAn37DF2Ud+tVFamxdZuQgJ9VDNH_GmX+pwyw@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix double free for req when failing to allocate
 sparse ext map
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, vshankar@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 11, 2023 at 2:14 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Introduced by commit d1f436736924 ("ceph: add new mount option to enable
> sparse reads") and will fold this into the above commit since it's
> still in the testing branch.
>
> Reported-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 17758cb607ec..3561c95d7e23 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -351,10 +351,8 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>
>         if (sparse) {
>                 err = ceph_alloc_sparse_ext_map(&req->r_ops[0]);
> -               if (err) {
> -                       ceph_osdc_put_request(req);
> +               if (err)
>                         goto out;
> -               }
>         }
>
>         dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
> --
> 2.39.0
>

Hi Xiubo,

Looks good, let's fold this into that commit since it's still testing
branch material.

Thanks,

                Ilya
