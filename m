Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F792406F9
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Aug 2020 15:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgHJNv3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Aug 2020 09:51:29 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45535 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726633AbgHJNv2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 10 Aug 2020 09:51:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597067485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b/L7LGn0GNJThbZ32LxX6WxNhl18Hx6kduB2ZOvENUc=;
        b=B6JrUxfhLe1h8zJpL7K3BlS9tY+jnw9gPwcHIJSzxqNLhfJWAkPUSc8uNA8B9YHVTg4Brq
        pO19d6hHewSQQGU7AlzF7JnKX4jTtoC2KUIccWrtHPNFqkm3uJv5+Dr2Hkq3ul2Fvdy4g+
        jIzOP4UgzW/iiJCgHV4e3RSbJMhMSNw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-qxLQx6w_MuGxMSnM8Switg-1; Mon, 10 Aug 2020 09:51:22 -0400
X-MC-Unique: qxLQx6w_MuGxMSnM8Switg-1
Received: by mail-ed1-f69.google.com with SMTP id v11so3253164edr.13
        for <ceph-devel@vger.kernel.org>; Mon, 10 Aug 2020 06:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b/L7LGn0GNJThbZ32LxX6WxNhl18Hx6kduB2ZOvENUc=;
        b=LXkOQ/FgdfrPrqMd6ZQ9G9x5lcIuXzXmksGP0MUfTx9Hn4HqAPRnUHIdQ/Rc89PQ6q
         tiq5aBdGzZPwQGtHp5A4QaKmvDAucM97XFjvgEqHIHZsfAOp1GFiSCIGyArC7+fNl1uz
         Zh/xCuCn/9q3FeKzPrR90O7a0m+1wOeo9ETRfe54++vZ12Vz1UjhLQucpEW1tGDrjtRk
         WqSvDS6BYdP2bizd5Y/8mk99FchfAD0Mb3Y5A2T+P/G0S9xRit28sb5oLgJK4el2WWpN
         lKw72cWaELAMgjfjQ+QCfJcdNreamkrE1vtq1pSE1HUHsjd/l2xpbrnYfxesdSmZZ+qv
         /gPg==
X-Gm-Message-State: AOAM531YrKiN285/7NPA0TUNbE6Yhk/MoQSThd5DWgElRdV5klxOrj2Y
        Iq42zUe/ltKWVWa6GDouZZDAywDUU7SoZffwwjSwgvAKM/K7hQpy8mIh8dR/NWG0au2QACRM0GJ
        uxF2d6sZ1TiIFNqlNeOp40/hhBMhVsUmmwOrsGQ==
X-Received: by 2002:a17:906:f202:: with SMTP id gt2mr21208816ejb.70.1597067480409;
        Mon, 10 Aug 2020 06:51:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+PgQwhPLCL2rAL21Q4KEmb2tYjtMqMgleeCNdfIqVq6sqOW3PjOPLEUBRUZlibqJsN6MyEXsebC8sIKVs6UE=
X-Received: by 2002:a17:906:f202:: with SMTP id gt2mr21208804ejb.70.1597067480169;
 Mon, 10 Aug 2020 06:51:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200731130421.127022-1-jlayton@kernel.org> <20200731130421.127022-10-jlayton@kernel.org>
 <CALF+zOnQ6diJv4bMbf-HSYmHusT_iE1dAqp-j_kjuqyLqfp-nw@mail.gmail.com> <526038.1597054155@warthog.procyon.org.uk>
In-Reply-To: <526038.1597054155@warthog.procyon.org.uk>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Mon, 10 Aug 2020 09:50:44 -0400
Message-ID: <CALF+zO=K8iE5y7_5MPS4Zg+stUmY4FQobop1DnsS71Dpn_YpOg@mail.gmail.com>
Subject: Re: [Linux-cachefs] [RFC PATCH v2 09/11] ceph: convert readpages to fscache_read_helper
To:     David Howells <dhowells@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-cachefs@redhat.com, idryomov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Aug 10, 2020 at 6:09 AM David Howells <dhowells@redhat.com> wrote:
>
> David Wysochanski <dwysocha@redhat.com> wrote:
>
> > Looks like fscache_shape_request() overrides any 'max_pages' value (actually
> > it is cachefiles_shape_request) , so it's unclear why the netfs would pass
> > in a 'max_pages' if it is not honored - seems like a bug maybe or it's not
> > obvious
>
> I think the problem is that cachefiles_shape_request() is applying the limit
> too early.  It's using it to cut down the number of pages in the original
> request (only applicable to readpages), but then the shaping to fit cache
> granules can exceed that, so it needs to be applied later also.
>
> Does the attached patch help?
>
> David
> ---
> diff --git a/fs/cachefiles/content-map.c b/fs/cachefiles/content-map.c
> index 2bfba2e41c39..ce05cf1d9a6e 100644
> --- a/fs/cachefiles/content-map.c
> +++ b/fs/cachefiles/content-map.c
> @@ -134,7 +134,8 @@ void cachefiles_shape_request(struct fscache_object *obj,
>         _enter("{%lx,%lx,%x},%llx,%d",
>                start, end, max_pages, i_size, shape->for_write);
>
> -       if (start >= CACHEFILES_SIZE_LIMIT / PAGE_SIZE) {
> +       if (start >= CACHEFILES_SIZE_LIMIT / PAGE_SIZE ||
> +           max_pages < CACHEFILES_GRAN_PAGES) {
>                 shape->to_be_done = FSCACHE_READ_FROM_SERVER;
>                 return;
>         }
> @@ -144,10 +145,6 @@ void cachefiles_shape_request(struct fscache_object *obj,
>         if (shape->i_size > CACHEFILES_SIZE_LIMIT)
>                 i_size = CACHEFILES_SIZE_LIMIT;
>
> -       max_pages = round_down(max_pages, CACHEFILES_GRAN_PAGES);
> -       if (end - start > max_pages)
> -               end = start + max_pages;
> -
>         granule = start / CACHEFILES_GRAN_PAGES;
>         if (granule / 8 >= object->content_map_size) {
>                 cachefiles_expand_content_map(object, i_size);
> @@ -185,6 +182,10 @@ void cachefiles_shape_request(struct fscache_object *obj,
>                 start = round_down(start, CACHEFILES_GRAN_PAGES);
>                 end   = round_up(end, CACHEFILES_GRAN_PAGES);
>
> +               /* Trim to the maximum size the netfs supports */
> +               if (end - start > max_pages)
> +                       end = round_down(start + max_pages, CACHEFILES_GRAN_PAGES);
> +
>                 /* But trim to the end of the file and the starting page */
>                 eof = (i_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>                 if (eof <= shape->proposed_start)
>

I tried this and got the same panic - I think i_size is the culprit
(it is larger than max_pages).  I'll send you a larger trace offline
with cachefiles/fscache debugging enabled if that helps, but below is
some custom tracing that may be enough because it shows before / after
shaping values.

Here's outline of the test (smaller rsize and readahead for simplicity):
# ./t1_rsize_lt_read.sh 4.1
Setting NFS vers=4.1
Mon 10 Aug 2020 09:34:18 AM EDT: 1. On NFS client, install and enable
cachefilesd
Mon 10 Aug 2020 09:34:18 AM EDT: 2. On NFS client, mount -o
vers=4.1,fsc,rsize=8192 127.0.0.1:/export/dir1 /mnt/dir1
Mon 10 Aug 2020 09:34:18 AM EDT: 3. On NFS client, dd if=/dev/zero
of=/mnt/dir1/file1.bin bs=16384 count=1
Mon 10 Aug 2020 09:34:18 AM EDT: 4. On NFS client, echo 3 >
/proc/sys/vm/drop_caches
Mon 10 Aug 2020 09:34:19 AM EDT: 5. On NFS client, ./nfs-readahead.sh
set /mnt/dir1 16384
Mon 10 Aug 2020 09:34:19 AM EDT: 6. On NFS client, dd
if=/mnt/dir1/file1.bin of=/dev/null
Mon 10 Aug 2020 09:34:19 AM EDT: 7. On NFS client, echo 3 >
/proc/sys/vm/drop_caches
Mon 10 Aug 2020 09:34:19 AM EDT: 8. On NFS client, dd
if=/mnt/dir1/file1.bin of=/dev/null


Console with custom nfs tracing
[   62.955355] t1_rsize_lt_rea (4840): drop_caches: 3
[   63.028786] fs/nfs/fscache.c:480 before read_helper_page_list pid
4882 inode ffff8902b4a2a828 cache ffff8902f50b5800 pages
ffffb4b4c0fafca8 max_pages 2
[   63.028804] fs/fscache/read_helper.c:347 pid 4882
fscache_read_helper before shape req ffff8902f50b5800 req->nr_pages 0
shape.actual_nr_pages 48 shape.proposed_nr_pages 4
[   63.037231] fs/fscache/read_helper.c:353 pid 4882
fscache_read_helper after shape req ffff8902f50b5800 req->nr_pages 0
shape.actual_nr_pages 4 shape.proposed_nr_pages 4
[   63.043421] fs/fscache/read_helper.c:531 pid 4882
fscache_read_helper before while req ffff8902f50b5800 req->nr_pages 1
shape.actual_nr_pages 4 shape.proposed_nr_pages 4
[   63.049498] fs/fscache/read_helper.c:531 pid 4882
fscache_read_helper before while req ffff8902f50b5800 req->nr_pages 2
shape.actual_nr_pages 4 shape.proposed_nr_pages 4
[   63.063708] fs/fscache/read_helper.c:531 pid 4882
fscache_read_helper before while req ffff8902f50b5800 req->nr_pages 3
shape.actual_nr_pages 4 shape.proposed_nr_pages 4
[   63.070114] fs/fscache/read_helper.c:531 pid 4882
fscache_read_helper before while req ffff8902f50b5800 req->nr_pages 4
shape.actual_nr_pages 4 shape.proposed_nr_pages 4
[   63.076438] fs/nfs/fscache.c:369 enter nfs_issue_op pid 4882 inode
ffff8902b4a2a828 cache ffff8902f50b5800 start 0 last 3
[   63.082964] fs/nfs/fscache.c:379 before readpage_async_filler pid
4882 inode ffff8902b4a2a828 cache ffff8902f50b5800 page
fffff42f08741a00
[   63.087591] fs/nfs/fscache.c:382 after readpage_async_filler pid
4882 inode ffff8902b4a2a828 cache ffff8902f50b5800 page
fffff42f08741a00 cache.error 0
[   63.093058] fs/nfs/fscache.c:379 before readpage_async_filler pid
4882 inode ffff8902b4a2a828 cache ffff8902f50b5800 page
fffff42f08288680
[   63.098927] fs/nfs/fscache.c:382 after readpage_async_filler pid
4882 inode ffff8902b4a2a828 cache ffff8902f50b5800 page
fffff42f08288680 cache.error 0
[   63.104507] fs/nfs/fscache.c:379 before readpage_async_filler pid
4882 inode ffff8902b4a2a828 cache ffff8902f50b5800 page
fffff42f082816c0
[   63.110922] fs/nfs/fscache.c:382 after readpage_async_filler pid
4882 inode ffff8902b4a2a828 cache ffff8902f50b5800 page
fffff42f082816c0 cache.error 0
[   63.111973] fs/nfs/fscache.c:523 pid 233 before io_done inode
ffff8902b4a2a828 bytes 8192 &req->cache ffff8902f50b5800 cache.pos 0
cache.len 16384
[   63.115407] fs/nfs/fscache.c:379 before readpage_async_filler pid
4882 inode ffff8902b4a2a828 cache ffff8902f50b5800 page
fffff42f067e8f40
[   63.126337] fs/nfs/fscache.c:382 after readpage_async_filler pid
4882 inode ffff8902b4a2a828 cache ffff8902f50b5800 page
fffff42f067e8f40 cache.error 0
[   63.131411] fs/nfs/fscache.c:388 exit nfs_issue_op pid 4882 inode
ffff8902b4a2a828 cache ffff8902f50b5800
[   63.131955] fs/nfs/fscache.c:523 pid 233 before io_done inode
ffff8902b4a2a828 bytes 8192 &req->cache ffff8902f50b5800 cache.pos 0
cache.len 16384
[   63.137012] fs/nfs/fscache.c:484 after read_helper_page_list pid
4882 inode ffff8902b4a2a828 cache ffff8902f50b5800 cache.pos 0
cache.len 16384 cache.nr_pages 4 pages ffffb4b4c0fafca8 ret 0
[   63.140922] page:fffff42f08741a00 refcount:2 mapcount:0
mapping:00000000727f3adc index:0x0
[   63.141091] mapping->aops:nfs_file_aops [nfs] dentry name:"file1.bin"
[   63.146475] fs/nfs/fscache.c:490 outside while(!list_empty(pages))
read_helper_page_list pid 4882 inode ffff8902b4a2a828 cache
ffff8902f50b5800 cache.pos 0 cache.len 16384 cache.nr_pages 4
[   63.146740] fs/fscache/read_helper.c:347 pid 4882
fscache_read_helper before shape req ffff8902f50b5800 req->nr_pages 0
shape.actual_nr_pages 3227832042 shape.proposed_nr_pages 1
[   63.153662] flags: 0x17ffffc0000006(referenced|uptodate)
[   63.153699] raw: 0017ffffc0000006 dead000000000100 dead000000000122
ffff8902b4a2a9a0
[   63.168174] fs/fscache/read_helper.c:353 pid 4882
fscache_read_helper after shape req ffff8902f50b5800 req->nr_pages 0
shape.actual_nr_pages 5 shape.proposed_nr_pages 1
[   63.193131] raw: 0000000000000000 0000000000000000 00000001ffffffff
ffff8902ecfe8000
[   63.203785] page dumped because: VM_BUG_ON_PAGE(!PageLocked(page))
[   63.206372] page->mem_cgroup:ffff8902ecfe8000
[   63.208333] ------------[ cut here ]------------
[   63.211081] kernel BUG at mm/filemap.c:1290!
[   63.213152] invalid opcode: 0000 [#1] SMP PTI

