Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAFA62FCF5
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2019 16:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfE3OLt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 May 2019 10:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33900 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfE3OLt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 May 2019 10:11:49 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 58ED0F4494
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 14:11:49 +0000 (UTC)
Received: from ovpn-112-65.rdu2.redhat.com (ovpn-112-65.rdu2.redhat.com [10.10.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E27C87944D;
        Thu, 30 May 2019 14:11:48 +0000 (UTC)
Date:   Thu, 30 May 2019 14:11:47 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     zyan@redhat.com
cc:     ceph-devel@vger.kernel.org
Subject: SnapServer::check_osd_map() and is_removed_snap()
Message-ID: <alpine.DEB.2.11.1905301402170.29218@piezo.novalocal>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 30 May 2019 14:11:49 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Zheng-

I'm trying to get rid of the removed_snaps member from pg_pool_t as this 
is a scaling problem for aged clusters with lots of removed snapshots.  
I'm down to a handful of users: rados cache tiered pools, and 
SnapServer::check_osd_map().  I'm not entirely following what the 
code is doing with all_purge vs all_purged.. do you mind taking a look?

If we can get away with not using the OSDMap's removed_snaps (and by 
extension is_removed_snap()) at all, that would be ideal.  If the MDS 
really *does* need to know which snaps have been purged from the 
rados pool, then we can instead switch to using the new_removed_snaps 
OSDMap member instead.  The difference is that new_removed_snaps includes 
the snaps that were removed in the current epoch only, so in order to 
reliably capture all removed snaps, the MDS would need to examine every 
OSDMap epoch (not just the latest map).

It looks to me like the MDS basically needs an ack that it's attempt to 
remove a snap has succeeded from the mon, and it's doing that by examining 
the resulting OSDMap.  The mon actually has a durable record for all 
deleted snaps, though, so I suspect the best fix for this is just 
to change the mds <-> mon protocol so that MRemoveSnaps gets an ack back 
after the snap is deleted (or has already been deleted).  Otherwise it 
will be a real challenge for the MDS to ensure that it finds out about 
deleted snaps in the fact of MDS restarts and possible gaps in the osdmap 
history...

Does that seem reasonable?

Thanks!
sage
