Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF32D367F63
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Apr 2021 13:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbhDVLQe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Apr 2021 07:16:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:33266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236062AbhDVLQd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 07:16:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E4A33AECB;
        Thu, 22 Apr 2021 11:15:57 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B21761E37A2; Thu, 22 Apr 2021 13:15:57 +0200 (CEST)
Date:   Thu, 22 Apr 2021 13:15:57 +0200
From:   Jan Kara <jack@suse.cz>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Hole punch races in Ceph
Message-ID: <20210422111557.GE26221@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

I'm looking into how Ceph protects against races between page fault and
hole punching (I'm unifying protection for this kind of races among
filesystems) and AFAICT it does not. What I have in mind in particular is a
race like:

CPU1					CPU2

ceph_fallocate()
  ...
  ceph_zero_pagecache_range()
					ceph_filemap_fault()
					  faults in page in the range being
					  punched
  ceph_zero_objects()

And now we have a page in punched range with invalid data. If
ceph_page_mkwrite() manages to squeeze in at the right moment, we might
even associate invalid metadata with the page I'd assume (but I'm not sure
whether this would be harmful). Am I missing something?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
