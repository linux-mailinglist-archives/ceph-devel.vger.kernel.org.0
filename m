Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614F617418C
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Feb 2020 22:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgB1VkC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Feb 2020 16:40:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgB1VkC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 28 Feb 2020 16:40:02 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ECD9246A2;
        Fri, 28 Feb 2020 21:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582926001;
        bh=AEk0+aCr3b+H4C3X0wgdTWBNAEqZtdwsitbMfcbcl0A=;
        h=Subject:From:To:Cc:Date:From;
        b=dhNdD9AhEzv8smcqpZozS5E96RX9ZNC+MkHT4bgwzRDGPXHB9QPfSHN0211vvkScb
         VMl4gSULaFvowY1bJbl9yWETOWAWUpYnpNYSM5T219VPOuAkakBDiG7WW7eLUIV9nm
         vF5wNc0Lx+eiLA1cO+YtNHLU5qGe2rXIvTXHHc3A=
Message-ID: <4a4d32dc5c4a44cca4ed31bb66d9cfcb0b1092c7.camel@kernel.org>
Subject: unsafe list walking in __kick_flushing_caps?
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     Ilya Dryomov <idryomov@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Fri, 28 Feb 2020 16:39:55 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Zheng,

I've been going over the cap handling code, and noticed some sketchy
looking locking in __kick_flushing_caps that was added by this patch:


commit e4500b5e35c213e0f97be7cb69328c0877203a79
Author: Yan, Zheng <zyan@redhat.com>
Date:   Wed Jul 6 11:12:56 2016 +0800

    ceph: use list instead of rbtree to track cap flushes
    
    We don't have requirement of searching cap flush by TID. In most cases,
    we just need to know TID of the oldest cap flush. List is ideal for this
    usage.
    
    Signed-off-by: Yan, Zheng <zyan@redhat.com>

While walking ci->i_cap_flush_list, __kick_flushing_caps drops and
reacquires the i_ceph_lock on each iteration. It looks like
__kick_flushing_caps could (e.g.) race with a reply from the MDS that
removes the entry from the list. Is there something that prevents that
that I'm not seeing?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

