Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833296F6998
	for <lists+ceph-devel@lfdr.de>; Thu,  4 May 2023 13:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjEDLM5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 May 2023 07:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjEDLM4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 May 2023 07:12:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D7E3A82
        for <ceph-devel@vger.kernel.org>; Thu,  4 May 2023 04:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683198725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJhEbMIRXCGxGOIO8pL0NanmUL0bQt2hnPwrarBkBZU=;
        b=CXIdKsVyNTBvtLmFzq0h01HQd3qpX0t2/AwxrGMS1JdzGjsj/8Mp7mL3jlXuR1lOwkorc2
        e5Cw0kbGXrX/oKqpuyaEo/J1iWLGwvfnaAu84KO7FoH9J69khIHev8SPM3KMu49SejxYNH
        QrYYi6O1jO0wIuELnUWGB736vydXhJ0=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-Quw1rVkcOkK1KkAIYt8qLQ-1; Thu, 04 May 2023 07:12:04 -0400
X-MC-Unique: Quw1rVkcOkK1KkAIYt8qLQ-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-528ab7097afso177404a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 04 May 2023 04:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683198723; x=1685790723;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mJhEbMIRXCGxGOIO8pL0NanmUL0bQt2hnPwrarBkBZU=;
        b=LFq0Lhpq6rjOToB9zI23rD+6DCgziPpfuAP0X36+M4iDb5EvT3Dn4nUe8XeeVF3HWz
         2F4IRXjmxZEbeSp0krVpwMv6vEZWtgLuYYVc4UWWxnc+dfef+CetCj2UHNKHu+OvM2AD
         Vh92mraqgbIDDyRG4/EalvQaqhCEycD6KJnOF6PXyj0fWurzTH4Kc5ujqv0hkYjn9mmm
         PEw8HDgc4DfHkdDfUCxCtV/JAteKshnDbBP4Fpx38rQo2TKWhnbEm1qau9uEIbW67s2/
         UgGBJbTHgfJJNWE63p1bINrgnos33D3Nz3O2c+rlULnSfmYed4phTvHRlFQLm6mSKgcd
         bNAg==
X-Gm-Message-State: AC+VfDx5nksv9F+HIoZ1NXUXttqEz+1UofoDy1mEp5Ee3ajRGSZfi5Fw
        Cl4g4n+W9PA32/OQm+Gy0bbXJOSFCQLfdPPxFdqv6nciuDGEMcxac6OsHFPcY6hkvpvsRW1qSUe
        eikcC6HE7L71EYtawL2Zndg==
X-Received: by 2002:a17:902:8d8e:b0:1a9:a554:c84 with SMTP id v14-20020a1709028d8e00b001a9a5540c84mr2995442plo.41.1683198722811;
        Thu, 04 May 2023 04:12:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6iksfF/g/y68XvYvpfA+AxD2aKXXwHJ1P6VmNMesvnzh59O5NYQjuYo48l44Koy43rr3M85w==
X-Received: by 2002:a17:902:8d8e:b0:1a9:a554:c84 with SMTP id v14-20020a1709028d8e00b001a9a5540c84mr2995426plo.41.1683198722459;
        Thu, 04 May 2023 04:12:02 -0700 (PDT)
Received: from [10.72.12.151] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id m1-20020a1709026bc100b001a1b808c1d8sm23326626plt.245.2023.05.04.04.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 04:12:02 -0700 (PDT)
Message-ID: <c69bb93b-4cf2-1449-d07d-d52f9eb98dee@redhat.com>
Date:   Thu, 4 May 2023 19:11:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ceph: fix excessive page cache usage
Content-Language: en-US
To:     Hu Weiwen <sehuww@mail.scut.edu.cn>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
References: <20230504082510.247-1-sehuww@mail.scut.edu.cn>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230504082510.247-1-sehuww@mail.scut.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Weiwen,

As discussed in another thread I have fold your change to my fix in V3.

Thanks

- Xiubo

On 5/4/23 16:25, Hu Weiwen wrote:
> Currently, `ceph_netfs_expand_readahead()` tries to align the read
> request with strip_unit, which by default is set to 4MB.  This means
> that small files will require at least 4MB of page cache, leading to
> inefficient usage of the page cache.
>
> Bound `rreq->len` to the actual file size to restore the previous page
> cache usage.
>
> Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
>
> We recently updated our kernel. And we are investigating the performance
> regression on our machine learning jobs.  For example, one of our jobs
> repeatedly read a dataset of 62GB, 100k files.  I expect all these IO
> request would hit the page cache, since we have more that 100GB memory
> for cache.  However, a lot of network IO is observed, and our HDD ceph
> cluster is fully loaded, resulting in very bad performance.
>
> The regression is bisected to commit
> 49870056005c ("ceph: convert ceph_readpages to ceph_readahead").
> This commit is merged in kernel 5.13.  After this commit, we need 400GB
> of memory to fully cache these 100k files, which is unacceptable.
>
> The post-EOF page cache is populated at:
> (gathered by `perf record -a -e filemap:mm_filemap_add_to_page_cache -g sleep 2`)
>
> python 3619706 [005] 3103609.736344: filemap:mm_filemap_add_to_page_cache: dev 0:62 ino 1002245af9b page=0x7daf4c pfn=0x7daf4c ofs=1048576
>          ffffffff9aca933a __add_to_page_cache_locked+0x2aa ([kernel.kallsyms])
>          ffffffff9aca933a __add_to_page_cache_locked+0x2aa ([kernel.kallsyms])
>          ffffffff9aca945d add_to_page_cache_lru+0x4d ([kernel.kallsyms])
>          ffffffff9acb66d8 readahead_expand+0x128 ([kernel.kallsyms])
>          ffffffffc0e68fbc netfs_rreq_expand+0x8c ([kernel.kallsyms])
>          ffffffffc0e6a6c2 netfs_readahead+0xf2 ([kernel.kallsyms])
>          ffffffffc104817c ceph_readahead+0xbc ([kernel.kallsyms])
>          ffffffff9acb63c5 read_pages+0x95 ([kernel.kallsyms])
>          ffffffff9acb6921 page_cache_ra_unbounded+0x161 ([kernel.kallsyms])
>          ffffffff9acb6a1d do_page_cache_ra+0x3d ([kernel.kallsyms])
>          ffffffff9acb6b67 ondemand_readahead+0x137 ([kernel.kallsyms])
>          ffffffff9acb700f page_cache_sync_ra+0xcf ([kernel.kallsyms])
>          ffffffff9acab80c filemap_get_pages+0xdc ([kernel.kallsyms])
>          ffffffff9acabe4e filemap_read+0xbe ([kernel.kallsyms])
>          ffffffff9acac285 generic_file_read_iter+0xe5 ([kernel.kallsyms])
>          ffffffffc1041b82 ceph_read_iter+0x182 ([kernel.kallsyms])
>          ffffffff9ad82bf0 new_sync_read+0x110 ([kernel.kallsyms])
>          ffffffff9ad83432 vfs_read+0x102 ([kernel.kallsyms])
>          ffffffff9ad858d7 ksys_read+0x67 ([kernel.kallsyms])
>          ffffffff9ad8597a __x64_sys_read+0x1a ([kernel.kallsyms])
>          ffffffff9b76563c do_syscall_64+0x5c ([kernel.kallsyms])
>          ffffffff9b800099 entry_SYSCALL_64_after_hwframe+0x61 ([kernel.kallsyms])
>              7fad6ca683cc __libc_read+0x4c (/lib/x86_64-linux-gnu/libpthread-2.31.so)
>
> The readahead is expanded too much.
>
>
>   fs/ceph/addr.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 6bb251a4d613..d508901d3739 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -197,6 +197,8 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
>   
>   	/* Now, round up the length to the next block */
>   	rreq->len = roundup(rreq->len, lo->stripe_unit);
> +	/* But do not exceed the file size */
> +	rreq->len = min(rreq->len, (size_t)(rreq->i_size - rreq->start));
>   }
>   
>   static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)

