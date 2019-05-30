Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E691D2FCE1
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2019 16:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfE3OHx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 May 2019 10:07:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbfE3OHw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 May 2019 10:07:52 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C9F013002619;
        Thu, 30 May 2019 14:07:52 +0000 (UTC)
Received: from [10.72.12.109] (ovpn-12-109.pek2.redhat.com [10.72.12.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 253781969E;
        Thu, 30 May 2019 14:07:50 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
Subject: New CephFS kernel client maintainer
To:     ceph-devel <ceph-devel@vger.kernel.org>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <23249968-661b-2d50-9261-8bcd114d7984@redhat.com>
Date:   Thu, 30 May 2019 22:07:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 30 May 2019 14:07:52 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello everyone.

I'd like to introduce new CephFS kernel client maintainer Jeff Layton 
<jlayton@redhat.com>. Jeff is a long time Linux kernel developer 
specializing in network file systems. He has worked on CephFS for three 
years. He also has made significant contributions to the kernel's NFS 
client and server, the CIFS client and the kernel's VFS layer.

I will continue to work on CephFS, but spend more time on improving 
CephFS metadata server.

Regards
Yan, Zheng
