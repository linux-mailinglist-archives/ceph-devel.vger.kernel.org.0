Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1FE5B6518
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Sep 2022 03:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiIMB3l (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Sep 2022 21:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiIMB3k (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Sep 2022 21:29:40 -0400
X-Greylist: delayed 530 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Sep 2022 18:29:38 PDT
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93095A1A5
        for <ceph-devel@vger.kernel.org>; Mon, 12 Sep 2022 18:29:37 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id EE0F561371
        for <ceph-devel@vger.kernel.org>; Tue, 13 Sep 2022 11:20:43 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id nmC1T9SWDtZK for <ceph-devel@vger.kernel.org>;
        Tue, 13 Sep 2022 11:20:43 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 7C1EB612BC
        for <ceph-devel@vger.kernel.org>; Tue, 13 Sep 2022 11:20:43 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 5D0F2680355; Tue, 13 Sep 2022 11:20:43 +1000 (AEST)
Date:   Tue, 13 Sep 2022 11:20:43 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     ceph-devel@vger.kernel.org
Subject: rbd unmap fails with "Device or resource busy"
Message-ID: <20220913012043.GA568834@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-Spam-Status: No, score=-0.0 required=5.0 tests=BAYES_40,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

What can make a "rbd unmap" fail, assuming the device is not mounted and not 
(obviously) open by any other processes?

linux-5.15.58
ceph-16.2.9

I have multiple XFS on rbd filesystems, and often create rbd snapshots, map 
and read-only mount the snapshot, perform some work on the fs, then unmount 
and unmap. The unmap regularly (about 1 in 10 times) fails like:

$ sudo rbd unmap /dev/rbd29
rbd: sysfs write failed
rbd: unmap failed: (16) Device or resource busy

I've double checked the device is no longer mounted, and, using "lsof" etc., 
nothing has the device open.

A "rbd unmap -f" can unmap the "busy" device but I'm concerned this may have 
undesirable consequences, e.g. ceph resource leakage, or even potential data 
corruption on non-read-only mounts.

I've found that waiting "a while", e.g. 5-30 minutes, will usually allow the 
"busy" device to be unmapped without the -f flag.

A simple "map/mount/read/unmount/unmap" test sees the unmap fail about 1 in 10 
times. When it fails it often takes 30 min or more for the unmap to finally 
succeed. E.g.:

----------------------------------------
#!/bin/bash

set -e

rbdname=pool/name

for ((i=0; ++i<=50; )); do
   dev=$(rbd map "${rbdname}")
   mount -oro,norecovery,nouuid "${dev}" /mnt/test

   dd if="/mnt/test/big-file" of=/dev/null bs=1G count=1
   umount /mnt/test
   # blockdev --flushbufs "${dev}"
   for ((j=0; ++j; )); do
     rbd unmap "${rdev}" && break
     sleep 5m
   done
done
----------------------------------------

Running "blockdev --flushbufs" prior to the unmap doesn't change the unmap 
failures.

What can I look at to see what's causing these unmaps to fail?

Chris
