Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83169717B10
	for <lists+ceph-devel@lfdr.de>; Wed, 31 May 2023 11:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbjEaJDA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 May 2023 05:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbjEaJCh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 31 May 2023 05:02:37 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AA310D9
        for <ceph-devel@vger.kernel.org>; Wed, 31 May 2023 02:02:13 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-5149b63151aso5775237a12.3
        for <ceph-devel@vger.kernel.org>; Wed, 31 May 2023 02:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1685523731; x=1688115731;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=82U6bUpm6YFNkGK5cbhaAjWwDgpxY2X/ujFBNt1W6jk=;
        b=A6KOMI+ewwQr8qcLpuyi659zu4D/Uwm4Riu4JCnMaYPF83lGbGHbPte+JTqL0ejSbq
         VHzPX/zoWMZKPg2ZijvaZZzouWRkcsu1Cq500nIEn8quQkOQ7DmDMJl9uUNWolomxRq+
         JLd/2jXH1F0vLqowGSqxr2lrm4n1twnt6EDhw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685523731; x=1688115731;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=82U6bUpm6YFNkGK5cbhaAjWwDgpxY2X/ujFBNt1W6jk=;
        b=jMvGSJsfsloXypTue2vNxfIRRxJrHxIom1Kwe8JIgfUQO1WqkbQflbaAW1X+1O91PE
         QdOKxktNBGTVownVNOnyHDGgA49BdWcdJzZJ2mypA7xekxcluYOzajIVE4cV/5OCuyTx
         WSwKbaxNa+C3EV1SdhszhUf6EDBiZFmqWdo/t3HljysjNJCeL/hwbxwo1hHGFheGW+UZ
         otj+kDoLFz9U7VZFkqluWOJ8acd4ZRaXe8DbDoJdWHbicqOzvJyaUg+CfGR0/WWm3tk5
         xVkPgVVUCvCE6V3MAzIIrhsCWiLvPLYN+Y8ByEbPG8AtqKUZlXtrpS+bRp2S3GCAPIjY
         TMUQ==
X-Gm-Message-State: AC+VfDxWcaydOlIo1FAm0qZLqE8y7yYm7wT59iXt6x7b66rWMpLPUSTu
        tnJlHeqkie8IAUDv8qVvWIVKK/+I4Ymj8ClpwPm8/Q==
X-Google-Smtp-Source: ACHHUZ54ruSZ4ErYRXWiU9UTWeerJcU9a8S+taczm8RKgsna09cTe6RnnExPREASsZbWk52M7ju665X7rMMjOFwIvBg=
X-Received: by 2002:a17:907:3f0d:b0:966:634d:9d84 with SMTP id
 hq13-20020a1709073f0d00b00966634d9d84mr5472507ejc.20.1685523730877; Wed, 31
 May 2023 02:02:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230531075026.480237-1-hch@lst.de> <20230531075026.480237-13-hch@lst.de>
In-Reply-To: <20230531075026.480237-13-hch@lst.de>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 31 May 2023 11:01:59 +0200
Message-ID: <CAJfpegutmdRtz1gPyX7MjrgqP-2186sCxtUiANO=8+EdnrLHrg@mail.gmail.com>
Subject: Re: [PATCH 12/12] fuse: use direct_write_fallback
To:     Christoph Hellwig <hch@lst.de>
Cc:     Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Chao Yu <chao@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 31 May 2023 at 09:51, Christoph Hellwig <hch@lst.de> wrote:
>
> Use the generic direct_write_fallback helper instead of duplicating the
> logic.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  fs/fuse/file.c | 24 ++----------------------
>  1 file changed, 2 insertions(+), 22 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 025973ad813e05..7a72dc0a691201 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1340,7 +1340,6 @@ static ssize_t fuse_cache_write_iter(struct kiocb *iocb, struct iov_iter *from)
>         struct file *file = iocb->ki_filp;
>         struct address_space *mapping = file->f_mapping;
>         ssize_t written = 0;
> -       ssize_t written_buffered = 0;
>         struct inode *inode = mapping->host;
>         ssize_t err;
>         struct fuse_conn *fc = get_fuse_conn(inode);
> @@ -1377,30 +1376,11 @@ static ssize_t fuse_cache_write_iter(struct kiocb *iocb, struct iov_iter *from)
>                 goto out;
>
>         if (iocb->ki_flags & IOCB_DIRECT) {
> -               loff_t pos, endbyte;
> -
>                 written = generic_file_direct_write(iocb, from);
>                 if (written < 0 || !iov_iter_count(from))
>                         goto out;
> -
> -               written_buffered = fuse_perform_write(iocb, from);
> -               if (written_buffered < 0) {
> -                       err = written_buffered;
> -                       goto out;
> -               }
> -               pos = iocb->ki_pos - written_buffered;
> -               endbyte = iocb->ki_pos - 1;
> -
> -               err = filemap_write_and_wait_range(file->f_mapping, pos,
> -                                                  endbyte);
> -               if (err)
> -                       goto out;
> -
> -               invalidate_mapping_pages(file->f_mapping,
> -                                        pos >> PAGE_SHIFT,
> -                                        endbyte >> PAGE_SHIFT);
> -
> -               written += written_buffered;
> +               written = direct_write_fallback(iocb, from, written,
> +                               generic_perform_write(iocb, from));

This should use fuse_perform_write().

Last version of the patch was correct; copy-paste error?

Thanks,
Miklos
