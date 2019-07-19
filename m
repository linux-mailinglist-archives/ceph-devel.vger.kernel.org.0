Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1885C6E4AE
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jul 2019 13:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfGSLHj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Jul 2019 07:07:39 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:32940 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfGSLHj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 19 Jul 2019 07:07:39 -0400
Received: by mail-ot1-f49.google.com with SMTP id q20so32302068otl.0
        for <ceph-devel@vger.kernel.org>; Fri, 19 Jul 2019 04:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=3bOaIySAg9pDv1xGDnqTpb4IwGAZTbAJyxheACMTP70=;
        b=kVHS18nIKjj8L7HDPgJY27+JrFtQbQLQ9cgICe0yHP61+lZf1tiOfM59QjSaBCtNrR
         KEKEIu9Q2k65XGeX64KZn5NxnPlJSFKFdTp/I2i7wN7CXvONpj+lwA5mtedE+PnYqcpw
         2y2zEUwDENO8v0DwnJFKnmOroHPpdz9kD4JpPWwAlbISlqLewM2N6hzq0mwjQRerObZL
         7x1U3yn4A2Yb+7SCV1JvAu9pfetQp7BCN//e0IErpiiD5cnrAS495aI1cdlRMYYBu5Ju
         gkaErZSDHRPTthAfFKZrRSFo8ji0zfplXjmrSQDPQpm+B7mSOYHmTamjwLx89xC/zI5B
         JY6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3bOaIySAg9pDv1xGDnqTpb4IwGAZTbAJyxheACMTP70=;
        b=tuj1PFYfvEa8beqLq2L9s/ikPZ6herz7A+960a+JdrCcolnD6o56t2LLbTAk7nAcMG
         xR4xQG7p47FkVdlb6xcYU5US6FtVSA8IBuNi3oJDKFBmfOpvr8AAbL6L1ZAjNQwo0Kcl
         ByltOfm4RYqsy4DcMF0xC+gsk0MkXS7cqTfIObM8BtXTdTlsKaLwcjnVSTtmoqaxzZ0Z
         kFk59/o/wEz/GOOR99Oru7MTFbQHkhMPoypG2Qyl49no+Ook999cl9bBt44oVLl+yMqU
         9iMiqdTbL/Jm3zPVzgRlXC2sXd67isrUag+4ti2f2tCzRN0qHWedykAEPU9vCdtSm6k8
         zRzg==
X-Gm-Message-State: APjAAAVl25FLpacYMreE5qywFJUzREVJ5gwKoZpEyA1CQVpEULCg0kOV
        KXjh+IbbJRlPq8clqLU1BRzopm0L6cHmS5GXLEjSl1uL
X-Google-Smtp-Source: APXvYqzdXsRANW49EKJzqXzB+7d1+Lp9LctSDmSTfnaJoO9aMsoCFEB4hl7o2SnxXrkStSPMYhJMxIu7TSX0wj2qgpY=
X-Received: by 2002:a9d:6f03:: with SMTP id n3mr3815485otq.283.1563534457896;
 Fri, 19 Jul 2019 04:07:37 -0700 (PDT)
MIME-Version: 1.0
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Fri, 19 Jul 2019 19:07:24 +0800
Message-ID: <CAKQB+fsGD4b_RE1yF3RQszne+xrcEVV9QZiObwwZ39GDCh6n5Q@mail.gmail.com>
Subject: cephfs kernel client umount stucks forever
To:     ceph-devel <ceph-devel@vger.kernel.org>, jlayton@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Recently I encountered a issue that cephfs kernel client umount stucks
forever. Under such condition, the call stack of umount process is
shown as below and it seems to be reasonable:

[~] # cat /proc/985427/stack
[<ffffffff81098bcd>] io_schedule+0xd/0x30
[<ffffffff8111ab6f>] wait_on_page_bit_common+0xdf/0x160
[<ffffffff8111b0ec>] __filemap_fdatawait_range+0xec/0x140
[<ffffffff8111b195>] filemap_fdatawait_keep_errors+0x15/0x40
[<ffffffff811ab5a9>] sync_inodes_sb+0x1e9/0x220
[<ffffffff811b15be>] sync_filesystem+0x4e/0x80
[<ffffffff8118203d>] generic_shutdown_super+0x1d/0x110
[<ffffffffa08a48cc>] ceph_kill_sb+0x2c/0x80 [ceph]
[<ffffffff81181ca4>] deactivate_locked_super+0x34/0x60
[<ffffffff811a2f56>] cleanup_mnt+0x36/0x70
[<ffffffff8108e86f>] task_work_run+0x6f/0x90
[<ffffffff81001a9b>] do_syscall_64+0x27b/0x2c0
[<ffffffff81a00071>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[<ffffffffffffffff>] 0xffffffffffffffff

From the debugfs entry, two write requests are indeed not complete but
I can't figure it out.
[/sys/kernel/debug/ceph/63be7de3-e137-4b6d-ab75-323b27f21254.client4475]
# cat osdc
REQUESTS 2 homeless 0
36      osd13   1.d069c5d       1.1d    [13,4,0]/13     [13,4,0]/13
 e327    10000000028.00000000    0x40002c        2       write
37      osd13   1.8088c98       1.18    [13,6,0]/13     [13,6,0]/13
 e327    10000000029.00000000    0x40002c        2       write
LINGER REQUESTS
BACKOFFS

The kernel version is 4.14 with some customized features and the
cluster is composed by 3 nodes.  On those nodes, CephFS is mount via
kernel client and the issue only happens on one node while others
umount the CephFS successfully.  I've already checked the upstream
patches and no related issues are found.  Currently, I try to
re-produce the issue in an environment with bad network quality
(emulated by tc, add some packet loss, corruption and latency to the
network between client and server).  Also, osdmap is tuned much more
frequently to trigger request resent on the client.  But, I got no
luck with above approach.

Is there any suggestion or idea that I could do to further investigate
the issue?  Thanks!

- Jerry
