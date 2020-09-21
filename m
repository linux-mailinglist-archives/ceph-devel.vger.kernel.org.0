Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF8A272986
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Sep 2020 17:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727293AbgIUPI3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Mon, 21 Sep 2020 11:08:29 -0400
Received: from out.roosit.eu ([212.26.193.44]:51212 "EHLO out.roosit.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbgIUPI2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 21 Sep 2020 11:08:28 -0400
X-Greylist: delayed 3203 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 11:08:27 EDT
Received: from sx.f1-outsourcing.eu (host-213.189.39.136.telnetsolutions.pl [213.189.39.136])
        by out.roosit.eu (8.14.7/8.14.7) with ESMTP id 08LEEwRV105229
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Mon, 21 Sep 2020 16:15:00 +0200
Received: from sx.f1-outsourcing.eu (localhost.localdomain [127.0.0.1])
        by sx.f1-outsourcing.eu (8.13.8/8.13.8) with ESMTP id 08LEEwqC015860;
        Mon, 21 Sep 2020 16:14:58 +0200
Date:   Mon, 21 Sep 2020 16:14:58 +0200
From:   "Marc Roos" <M.Roos@f1-outsourcing.eu>
To:     ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Message-ID: <"H00000710017cb1c.1600697698.sx.f1-outsourcing.eu*"@MHS>
Subject: Understanding what ceph-volume does, with bootstrap-osd/ceph.keyring, tmpfs
x-scalix-Hops: 1
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



When I create a new encrypted osd with ceph volume[1] 

I assume something like this is being done, please correct what is 
wrong.

- it creates the pv on the block device
- it creates the ceph vg on the block device
- it creates the osd lv in the vg
- it uses cryptsetup to encrypt this lv
  (or is there some internal support for luks in lvm?)
- it sets all the tags on the vg (shown by: lvs -o lv_tags vg)
- it creates and enables ceph-volume@lvm-osdid-osdfsid
- it creates and enables ceph-osd@osdid

When a node is restarted, these lvm osds are started with
- running ceph-volume@lvm-osdid-osdfsid (creating this tmpfs mount?)
- running ceph-osd@osdid


Q1: I had to create bootstrap-osd/ceph.keyring (ownership root.root). 
For what is that being used? Does it need to exist upon node restart?

Q2: I had some issues with a node starting, solving this with adding a 
nofail to the fstab. How is this done with ceph-volume?

Q3: Why these strange permissions on the mounted folder? 
drwxrwxrwt  2 ceph ceph 340 Sep 19 15:24 ceph-40

Q4: Where is this luks passphrase stored?

Q5: Where does this tmpfs+content come from? How can I mount this myself 
from the command line?

Q6: My lvm tags show ceph.crush_device_class=None, while ceph osd tree 
shows the correct class. Is this correct?

Q7: I saw in my ceph-volume output sometimes 'disabling cephx', what 
does this mean? How can I verify this and fix it?

Links to manuals are also welcome, these ceph-volume[2] are not to clear 
about this.


[1]
ceph-volume lvm create --data /dev/sdk --dmcrypt

[2]
https://docs.ceph.com/en/latest/ceph-volume/lvm/activate/
