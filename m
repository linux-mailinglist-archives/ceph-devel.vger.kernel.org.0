Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A80461ABB
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Nov 2021 16:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343568AbhK2PZ3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Nov 2021 10:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbhK2PX3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Nov 2021 10:23:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAD8C061574
        for <ceph-devel@vger.kernel.org>; Mon, 29 Nov 2021 05:36:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2259461516
        for <ceph-devel@vger.kernel.org>; Mon, 29 Nov 2021 13:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45441C004E1;
        Mon, 29 Nov 2021 13:36:28 +0000 (UTC)
Date:   Mon, 29 Nov 2021 14:36:25 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
Subject: Questions about ceph/cephfs
Message-ID: <20211129133625.4ftmctptggvpbm7n@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hey Jeff,
Hey everyone,

I have a question about the relationship between the cephfs kernel
client/filesystem and the code in [1].

I'm working on patches to let cephfs support mapped mounts. I've got
everything in place and I'm able to run the full mapped mounts/vfs
testsuite against a ceph cluster. So things like:

mount -t ceph 1.2.3.4:6789:/ /mnt -o name=admin,secret=wootwoot
mount-idmapped --map-mount b:1000:0:1 /mnt /opt

(Where in /opt all inodes owned by id 1000 are owned by id 0 and callers
with id 0 write files to disk as id 1000.)

My next step was to read to the ceph code in github.com/ceph/ceph to
make sure that I don't miss any corner cases that wouldn't work
correctly with mapped mounts after the relevant kernel changes.

So I read through [1] and I could use some guidance if possible. The
code in there to me reads like it is a full implementation of cephfs in
userspace and I'm wondering how this related to the cephfs kernel
client/filesystem.

The client code in [1] seems to implement full-blown userspace path
lookup and permission checking that seems to reimplement the vfs layer
in userspace.
A lot of the helpers such as ceph_ll_mknod() in addition expose a
UserPerms struct that seems to be settable by the caller which is used
during lookup.

How does this permission/path lookup code relate to the cephfs kernel
client/filesystem? Do they interact with each other in any way?

Thanks for taking the time to answer!
Christian

[1]: https://github.com/ceph/ceph/tree/master/src/client/*
