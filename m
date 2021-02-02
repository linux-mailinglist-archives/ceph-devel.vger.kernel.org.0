Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D0530BDBF
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Feb 2021 13:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhBBMIs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Feb 2021 07:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbhBBMIg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Feb 2021 07:08:36 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F2AC0613D6;
        Tue,  2 Feb 2021 04:07:54 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id f6so803602ioz.5;
        Tue, 02 Feb 2021 04:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Z1Bxd51G9PFZlZUPxb0tknKCVZuSRzLJsXGcl6g4MA=;
        b=QjY2M8irIo15Nbgs2hdMSJbtCu32+5wy1ex9hmxirFo36YWF38CDN4OFHVaIJgapfV
         OyY0l43yfFMijyB3xfAhFLfJ1i2jRAilptDwW9NpK9LmuMfwX6+jUaLcnWC59RpJEJ+O
         Bz2zBhSWnwV7qSvCfP47Yshnr4Hv7ofmErgr8wtY4LVznzPf1KLuVUgTvIWHpwfXfmAh
         Y6WGpyCjr82QCHezrCW2FAp2m1JUAhd6O7U//rf9eikDe7GbcZAMs7b733aSsKQTw3YV
         TOK6dYemFLNZpYDuoRy69pvn8n9Spjfii8Sp9Sb+y57CzMUqPkIh+U+dJZ33XWxyiBV2
         PV8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Z1Bxd51G9PFZlZUPxb0tknKCVZuSRzLJsXGcl6g4MA=;
        b=L/xM1XVBOvQ1Dd4K1ypEj0DLKqjzTSmYilEBBTSE52zK8NNrD1gDeP2Pbb0cCynIb4
         NUX7gE6x9oz6O5ds4CBj8r/4fx76dgJDt/UBJvViiLhC0F2OunOBDhTjx5HcUaLM+8WG
         XvR+hgg9JQPKBACkmFWGasCSx2Wy9PkOc12H+SGgX8DlwJrBMgJsEeqFE7pCYgHD7rp9
         ZXkz/fPHWus2UkgpEawplqWYS28hKoAUtv28OAwRM+PBeD555F/xqdf2MNZjVkCntun7
         PvYVBFljKT8OSe8674849+N+6ZV6Nmm52JKsu5HppdUPqmFdNtXUm9kggKoDj1Z9Q/U7
         Q1pA==
X-Gm-Message-State: AOAM532eqEWCT/3fs0NJLv6yxwZWy97ok5v3m3tCJCHl3Kl2IrkokGQw
        ds33EEJoq8ujWuuAaOUivYasEJ42OtHcCaZtkwISNxF+GWs=
X-Google-Smtp-Source: ABdhPJwX2XUfIpcD1K9CN8862ws3/tQ8uJhe8/2F12UsPTQub6Pbf7HdYqxREoWGrkmeCBUsGpqcRfnBXunVVJqQkwY=
X-Received: by 2002:a05:6638:d6:: with SMTP id w22mr2851011jao.93.1612267674216;
 Tue, 02 Feb 2021 04:07:54 -0800 (PST)
MIME-Version: 1.0
References: <1612165930-110076-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1612165930-110076-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 2 Feb 2021 13:07:50 +0100
Message-ID: <CAOi1vP_ifWsyOjXo2NaDQnAT9Gn22442KuUXp1LjDCWfpH5yuQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: Replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Feb 1, 2021 at 8:52 AM Jiapeng Chong
<jiapeng.chong@linux.alibaba.com> wrote:
>
> Fix the following coccicheck warning:
>
> ./fs/ceph/debugfs.c:347:0-23: WARNING: congestion_kb_fops should be
> defined with DEFINE_DEBUGFS_ATTRIBUTE.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  fs/ceph/debugfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 66989c8..617327e 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -344,8 +344,8 @@ static int congestion_kb_get(void *data, u64 *val)
>         return 0;
>  }
>
> -DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
> -                       congestion_kb_set, "%llu\n");
> +DEFINE_DEBUGFS_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
> +                         congestion_kb_set, "%llu\n");
>
>
>  void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)

Hi Jiapeng,

What is the benefit of this conversion?

From a quick look, with DEFINE_DEBUGFS_ATTRIBUTE writeback_congestion_kb
file would no longer be seekable.  It may not matter much, but something
that should have been mentioned.

Futher, debugfs_create_file() creates a full proxy for fops, protecting
against removal races.  DEFINE_DEBUGFS_ATTRIBUTE adds its own protection
but just for ->read() and ->write().  I don't think we need both.

Thanks,

                Ilya
