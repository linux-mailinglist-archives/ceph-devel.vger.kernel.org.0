Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A4633238
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 16:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbfFCOeG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 10:34:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728872AbfFCOeG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 3 Jun 2019 10:34:06 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CBC7730C2516
        for <ceph-devel@vger.kernel.org>; Mon,  3 Jun 2019 14:33:57 +0000 (UTC)
Received: from ovpn-112-65.rdu2.redhat.com (ovpn-112-65.rdu2.redhat.com [10.10.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D69B600CC
        for <ceph-devel@vger.kernel.org>; Mon,  3 Jun 2019 14:33:57 +0000 (UTC)
Date:   Mon, 3 Jun 2019 14:33:56 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     ceph-devel@vger.kernel.org
Subject: ANNOUNCE: moving the ceph-devel list to ceph.io
Message-ID: <alpine.DEB.2.11.1906022104460.3107@piezo.novalocal>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 03 Jun 2019 14:33:57 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi everyone,

We are splitting the ceph-devel@vger.kernel.org list into two:

- ceph-devel@ceph.io 

  This will be the new general purpose Ceph development discussion list.  
  We encourage all subscribers to the current ceph-devel@vger.kernel.org to 
  subscribe to this new list.

  Subscribe to the new ceph-devel list now at:

    https://lists.ceph.io/postorius/lists/ceph-devel.ceph.io/

- ceph-devel@vger.kernel.org

  The current list will continue to exist, but its role will shift to  Linux 
  kernel-related traffic, including kernel patches and discussion of 
  implementation details for the kernel client code.

  At some point in the future, when all non-kernel discussion has shifted 
  to the new list, you might want to unsubscribe from the old list.

For the next week or two, please direct discussion at both lists.  Once a 
bit of time has passed and most active developers have subscribed to the 
new list, we will focus discussion on the new list only.

We will send several more emails to the old list to remind people to 
subscribe to the new list.

Why are we doing this?

1 The new list is mailman and managed by the Ceph community, which means
  that when people have problems with subscribe, mails being lost, or any 
  other list-related problems, we can actually do something about it.  
  Currently we have no real ability to perform any management-related tasks 
  on the vger list.

2 The vger majordomo software also has some frustrating 
  features/limitations, the most notable being that it only accepts 
  plaintext email; anything with MIME or HTML formatting is rejected.  This 
  confuses many users.

3 The kernel development and general Ceph development have slightly
  different modes of collaboration.  Kernel code review is based on email 
  patches to the list and reviewing via email, which can be noisy and 
  verbose for those not involved in kernel development.  The Ceph userspace 
  code is handled via github pull requests, which capture both proposed 
  changes and code review.

Thanks!

