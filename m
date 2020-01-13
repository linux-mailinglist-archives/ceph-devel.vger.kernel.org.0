Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5C138FC3
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jan 2020 12:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgAMLHd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jan 2020 06:07:33 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33794 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726193AbgAMLHc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 06:07:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578913651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CSp5CSlRAkWik+CP1ZwTRD5V03oDDFG/7qhxVbKuMgs=;
        b=E1TMnAYqIVy86gYdHUrJNczyvoukebGhuFldcRLrBT+bXr6sYOPkqiQEkLIwnOja2fkGl7
        lzl+bvaYUGKLUenCW2JnTFAIB3mXZFyr5Z9XbOMX/46ZYDjIARNcrkzieIsuY3dERRh4Mk
        hrFh7ycm95Bsw5kL/OwpAzNw01L6MOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-osDuL6vyOgyx5dKRVTQkfw-1; Mon, 13 Jan 2020 06:07:27 -0500
X-MC-Unique: osDuL6vyOgyx5dKRVTQkfw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B57DC1005514;
        Mon, 13 Jan 2020 11:07:26 +0000 (UTC)
Received: from [10.72.12.95] (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6500187EE6;
        Mon, 13 Jan 2020 11:07:21 +0000 (UTC)
Subject: Re: [RFC PATCH 0/9] ceph: add asynchronous create functionality
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com
References: <20200110205647.311023-1-jlayton@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <f3d6ac41-73d5-2990-feff-85365cd3700d@redhat.com>
Date:   Mon, 13 Jan 2020 19:07:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200110205647.311023-1-jlayton@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/11/20 4:56 AM, Jeff Layton wrote:
> I recently sent a patchset that allows the client to do an asynchronous
> UNLINK call to the MDS when it has the appropriate caps and dentry info.
> This set adds the corresponding functionality for creates.
> 
> When the client has the appropriate caps on the parent directory and
> dentry information, and a delegated inode number, it can satisfy a
> request locally without contacting the server. This allows the kernel
> client to return very quickly from an O_CREAT open, so it can get on
> with doing other things.
> 
> These numbers are based on my personal test rig, which is a KVM client
> vs a vstart cluster running on my workstation (nothing scientific here).
> 
> A simple benchmark (with the cephfs mounted at /mnt/cephfs):
> -------------------8<-------------------
> #!/bin/sh
> 
> TESTDIR=/mnt/cephfs/test-dirops.$$
> 
> mkdir $TESTDIR
> stat $TESTDIR
> echo "Creating files in $TESTDIR"
> time for i in `seq 1 10000`; do
>      echo "foobarbaz" > $TESTDIR/$i
> done
> -------------------8<-------------------
> 
> With async dirops disabled:
> 
> real	0m9.865s
> user	0m0.353s
> sys	0m0.888s
> 
> With async dirops enabled:
> 
> real	0m5.272s
> user	0m0.104s
> sys	0m0.454s
> 
> That workload is a bit synthetic though. One workload we're interested
> in improving is untar. Untarring a deep directory tree (random kernel
> tarball I had laying around):
> 
> Disabled:
> $ time tar xf ~/linux-4.18.0-153.el8.jlayton.006.tar
> 
> real	1m35.774s
> user	0m0.835s
> sys	0m7.410s
> 
> Enabled:
> $ time tar xf ~/linux-4.18.0-153.el8.jlayton.006.tar
> 
> real	1m32.182s
> user	0m0.783s
> sys	0m6.830s
> 
> Not a huge win there. I suspect at this point that synchronous mkdir
> may be serializing behind the async creates.
> 
> It needs a lot more performance tuning and analysis, but it's now at the
> point where it's basically usable. To enable it, turn on the
> ceph.enable_async_dirops module option.
> 
> There are some places that need further work:
> 
> 1) The MDS patchset to delegate inodes to the client is not yet merged:
> 
>      https://github.com/ceph/ceph/pull/31817
> 
> 2) this is 64-bit arch only for the moment. I'm using an xarray to track
> the delegated inode numbers, and those don't do 64-bit indexes on
> 32-bit machines. Is anyone using 32-bit ceph clients? We could probably
> build an xarray of xarrays if needed.
> 
> 3) The error handling is still pretty lame. If the create fails, it'll
> set a writeback error on the parent dir and the inode itself, but the
> client could end up writing a bunch before it notices, if it even
> bothers to check. We probably need to do better here. I'm open to
> suggestions on this bit especially.
> 
> Jeff Layton (9):
>    ceph: ensure we have a new cap before continuing in fill_inode
>    ceph: print name of xattr being set in set/getxattr dout message
>    ceph: close some holes in struct ceph_mds_request
>    ceph: make ceph_fill_inode non-static
>    libceph: export ceph_file_layout_is_valid
>    ceph: decode interval_sets for delegated inos
>    ceph: add flag to delegate an inode number for async create
>    ceph: copy layout, max_size and truncate_size on successful sync
>      create
>    ceph: attempt to do async create when possible
> 
>   fs/ceph/caps.c               |  31 +++++-
>   fs/ceph/file.c               | 202 +++++++++++++++++++++++++++++++++--
>   fs/ceph/inode.c              |  57 +++++-----
>   fs/ceph/mds_client.c         | 130 ++++++++++++++++++++--
>   fs/ceph/mds_client.h         |  12 ++-
>   fs/ceph/super.h              |  10 ++
>   fs/ceph/xattr.c              |   5 +-
>   include/linux/ceph/ceph_fs.h |   8 +-
>   net/ceph/ceph_fs.c           |   1 +
>   9 files changed, 396 insertions(+), 60 deletions(-)
> 

client should wait for reply of aysnc create, before sending cap message 
or request (which operates on the creating inode) to mds


see commit "client: wait for async creating before sending request or 
cap message" in https://github.com/ceph/ceph/pull/32576


