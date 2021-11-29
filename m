Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E8C461770
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Nov 2021 15:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241565AbhK2OI1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Nov 2021 09:08:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52638 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240310AbhK2OG1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Nov 2021 09:06:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6958361538
        for <ceph-devel@vger.kernel.org>; Mon, 29 Nov 2021 14:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEE5C004E1;
        Mon, 29 Nov 2021 14:03:07 +0000 (UTC)
Date:   Mon, 29 Nov 2021 15:03:04 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
Subject: Re: Questions about ceph/cephfs
Message-ID: <20211129140304.kignvxgyz7ahierj@wittgenstein>
References: <20211129133625.4ftmctptggvpbm7n@wittgenstein>
 <78b163c7bbc8ebaebcdc09561df960628447182d.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <78b163c7bbc8ebaebcdc09561df960628447182d.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Nov 29, 2021 at 08:57:37AM -0500, Jeff Layton wrote:
> On Mon, 2021-11-29 at 14:36 +0100, Christian Brauner wrote:
> > Hey Jeff,
> > Hey everyone,
> > 
> > I have a question about the relationship between the cephfs kernel
> > client/filesystem and the code in [1].
> > 
> > I'm working on patches to let cephfs support mapped mounts. I've got
> > everything in place and I'm able to run the full mapped mounts/vfs
> > testsuite against a ceph cluster. So things like:
> > 
> > mount -t ceph 1.2.3.4:6789:/ /mnt -o name=admin,secret=wootwoot
> > mount-idmapped --map-mount b:1000:0:1 /mnt /opt
> > 
> 
> Sounds like a cool feature.
> 
> > (Where in /opt all inodes owned by id 1000 are owned by id 0 and callers
> > with id 0 write files to disk as id 1000.)
> > 
> > My next step was to read to the ceph code in github.com/ceph/ceph to
> > make sure that I don't miss any corner cases that wouldn't work
> > correctly with mapped mounts after the relevant kernel changes.
> > 
> > So I read through [1] and I could use some guidance if possible. The
> > code in there to me reads like it is a full implementation of cephfs in
> > userspace and I'm wondering how this related to the cephfs kernel
> > client/filesystem.
> > 
> > The client code in [1] seems to implement full-blown userspace path
> > lookup and permission checking that seems to reimplement the vfs layer
> > in userspace.
> > A lot of the helpers such as ceph_ll_mknod() in addition expose a
> > UserPerms struct that seems to be settable by the caller which is used
> > during lookup.
> > 
> > How does this permission/path lookup code relate to the cephfs kernel
> > client/filesystem? Do they interact with each other in any way?
> > 
> > Thanks for taking the time to answer!
> > Christian
> > 
> > [1]: https://github.com/ceph/ceph/tree/master/src/client/*
> 
> There are really two "official" cephfs clients: the userland client
> which is (mostly) represented by src/client in the userland ceph tree,
> and the kernel cephfs client (aka the kclient), which is (mostly)
> fs/ceph and net/ceph in the Linux kernel tree.
> 
> The userland code usually gets compiled into libcephfs.so and is the
> backend engine for ceph-fuse, the nfs-ganesha FSAL driver, and the samba
> vfs backend driver, as well as a bunch of testcases in the ceph tree.
> 
> libcephfs communicates directly with the cluster without interacting
> with any of the kernel ceph code, so ceph-fuse, ganesha, etc. do use the
> userland code for lookups and permission checks.
> 
> Technically, the kclient is the reimplentation. Most of the ceph and
> libceph code in the kernel has been copied/reimplemented from the ceph
> userland code. There is no real dependency between the kclient and
> libcephfs.
> 
> Maintaining the kclient is a continual game of catchup, unfortunately,
> though in some cases we do leading edge client development there instead
> and play catchup in the userland client.

Thank you for answering this so quickly this makes my life a lot easier!
This is good news as this means that the kernel changes to cephfs should
be fairly simple and self-contained. I'll continue polishing them and
will send them out once ready.

Thanks again!
Christian
