Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B62332269
	for <lists+ceph-devel@lfdr.de>; Sun,  2 Jun 2019 09:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfFBHUg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 2 Jun 2019 03:20:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfFBHUg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 2 Jun 2019 03:20:36 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D0F9307D854;
        Sun,  2 Jun 2019 06:43:13 +0000 (UTC)
Received: from [10.72.12.19] (ovpn-12-19.pek2.redhat.com [10.72.12.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 066975D739;
        Sun,  2 Jun 2019 06:43:10 +0000 (UTC)
Subject: Re: [PATCH] ceph: use ceph_evict_inode to cleanup inode's resource
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idryomov@redhat.com,
        jlayton@redhat.com
References: <20190602022546.16195-1-zyan@redhat.com>
 <20190602024316.GT17978@ZenIV.linux.org.uk>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <c609c244-723f-7801-9de7-b2343e24c7ed@redhat.com>
Date:   Sun, 2 Jun 2019 14:43:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190602024316.GT17978@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Sun, 02 Jun 2019 06:43:13 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 6/2/19 10:43 AM, Al Viro wrote:
> On Sun, Jun 02, 2019 at 10:25:46AM +0800, Yan, Zheng wrote:
>> remove_session_caps() relies on __wait_on_freeing_inode(), to wait for
>> freezing inode to remove its caps. But VFS wakes freeing inode waiters
>> before calling destroy_inode().
> 
> *blink*
> 
> Which tree is that against?
> 
>> -static void ceph_i_callback(struct rcu_head *head)
>> -{
>> -	struct inode *inode = container_of(head, struct inode, i_rcu);
>> -	struct ceph_inode_info *ci = ceph_inode(inode);
>> -
>> -	kfree(ci->i_symlink);
>> -	kmem_cache_free(ceph_inode_cachep, ci);
>> -}
> 
> ... is gone from mainline, and AFAICS not reintroduced in ceph tree.
> What am I missing here?
> 

Sorry, I should send it ceph-devel list

Yan, Zheng

