Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DF6461B57
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Nov 2021 16:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344033AbhK2Pxc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Nov 2021 10:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbhK2PvU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Nov 2021 10:51:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8656C08E9BE
        for <ceph-devel@vger.kernel.org>; Mon, 29 Nov 2021 05:57:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49C2E6152D
        for <ceph-devel@vger.kernel.org>; Mon, 29 Nov 2021 13:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43068C004E1;
        Mon, 29 Nov 2021 13:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638194258;
        bh=jO7+5URP9b4Z2P3PzMWlhh47oBy3cQKQRdYDxfZSIss=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vJYz8GVn3Z9/l3mUbZmpmhBc0sDxvoe71YfkoEBvDhz43Ey+pbNbLM/NbuWm80+hJ
         eRHOs0lMdNGvwxAhnkIBP4F0MK1CjnnjmSOvUh6h1pfSuEWENTjENAd4UYSX8w2Sx1
         yyY/SW+GxGJsmaonMZPog1IVqJSZwOCz9h0aRWiJZ0iiJq8Z6+EhVhxQCqJcqx/m5t
         Hmc23csusw7qH8pGwplTEpBvulgxXcYRuJc1Td40FE+r7klRGiQcfj9ptcCT2hkEYw
         /ROsmLVCNdpRx8kl/+zpsKUSUkWzTGXhrRM990CPAMybRnqd3ZOi9rxMLvwNLp/+rb
         nbF5pvtlWBP4w==
Message-ID: <78b163c7bbc8ebaebcdc09561df960628447182d.camel@kernel.org>
Subject: Re: Questions about ceph/cephfs
From:   Jeff Layton <jlayton@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christian Brauner <brauner@kernel.org>, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 29 Nov 2021 08:57:37 -0500
In-Reply-To: <20211129133625.4ftmctptggvpbm7n@wittgenstein>
References: <20211129133625.4ftmctptggvpbm7n@wittgenstein>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-11-29 at 14:36 +0100, Christian Brauner wrote:
> Hey Jeff,
> Hey everyone,
> 
> I have a question about the relationship between the cephfs kernel
> client/filesystem and the code in [1].
> 
> I'm working on patches to let cephfs support mapped mounts. I've got
> everything in place and I'm able to run the full mapped mounts/vfs
> testsuite against a ceph cluster. So things like:
> 
> mount -t ceph 1.2.3.4:6789:/ /mnt -o name=admin,secret=wootwoot
> mount-idmapped --map-mount b:1000:0:1 /mnt /opt
> 

Sounds like a cool feature.

> (Where in /opt all inodes owned by id 1000 are owned by id 0 and callers
> with id 0 write files to disk as id 1000.)
> 
> My next step was to read to the ceph code in github.com/ceph/ceph to
> make sure that I don't miss any corner cases that wouldn't work
> correctly with mapped mounts after the relevant kernel changes.
> 
> So I read through [1] and I could use some guidance if possible. The
> code in there to me reads like it is a full implementation of cephfs in
> userspace and I'm wondering how this related to the cephfs kernel
> client/filesystem.
> 
> The client code in [1] seems to implement full-blown userspace path
> lookup and permission checking that seems to reimplement the vfs layer
> in userspace.
> A lot of the helpers such as ceph_ll_mknod() in addition expose a
> UserPerms struct that seems to be settable by the caller which is used
> during lookup.
> 
> How does this permission/path lookup code relate to the cephfs kernel
> client/filesystem? Do they interact with each other in any way?
> 
> Thanks for taking the time to answer!
> Christian
> 
> [1]: https://github.com/ceph/ceph/tree/master/src/client/*

There are really two "official" cephfs clients: the userland client
which is (mostly) represented by src/client in the userland ceph tree,
and the kernel cephfs client (aka the kclient), which is (mostly)
fs/ceph and net/ceph in the Linux kernel tree.

The userland code usually gets compiled into libcephfs.so and is the
backend engine for ceph-fuse, the nfs-ganesha FSAL driver, and the samba
vfs backend driver, as well as a bunch of testcases in the ceph tree.

libcephfs communicates directly with the cluster without interacting
with any of the kernel ceph code, so ceph-fuse, ganesha, etc. do use the
userland code for lookups and permission checks.

Technically, the kclient is the reimplentation. Most of the ceph and
libceph code in the kernel has been copied/reimplemented from the ceph
userland code. There is no real dependency between the kclient and
libcephfs.

Maintaining the kclient is a continual game of catchup, unfortunately,
though in some cases we do leading edge client development there instead
and play catchup in the userland client.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>
