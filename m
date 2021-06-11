Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7055B3A43F9
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jun 2021 16:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhFKOXS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Jun 2021 10:23:18 -0400
Received: from discipline.rit.edu ([129.21.6.207]:15486 "HELO
        discipline.rit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S231180AbhFKOXR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Jun 2021 10:23:17 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jun 2021 10:23:17 EDT
Received: (qmail 9929 invoked by uid 501); 11 Jun 2021 14:14:38 -0000
From:   Andrew W Elble <aweits@rit.edu>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, pfmeec@rit.edu
Subject: Re: [PATCH 5/5] ceph: fold ceph_update_writeable_page into ceph_write_begin
References: <20200916173854.330265-1-jlayton@kernel.org>
        <20200916173854.330265-6-jlayton@kernel.org>
        <7817f98d3b2daafe113bf8290cc8c7adbb86fe99.camel@kernel.org>
Date:   Fri, 11 Jun 2021 10:14:38 -0400
In-Reply-To: <7817f98d3b2daafe113bf8290cc8c7adbb86fe99.camel@kernel.org> (Jeff
        Layton's message of "Wed, 16 Sep 2020 15:16:19 -0400")
Message-ID: <m2h7i45vzl.fsf@discipline.rit.edu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (berkeley-unix)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


We're seeing file corruption while running 5.10, bisected to 1cc1699070bd:

>> +static int ceph_write_begin(struct file *file, struct address_space *mapping,
>> +			    loff_t pos, unsigned len, unsigned flags,
>> +			    struct page **pagep, void **fsdata)

<snip>

>> +		/*
>> +		 * In some cases we don't need to read at all:
>> +		 * - full page write
>> +		 * - write that lies completely beyond EOF
>> +		 * - write that covers the the page from start to EOF or beyond it
>> +		 */
>> +		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
>> +		    (pos >= i_size_read(inode)) ||

Shouldn't this be '((pos & PAGE_MASK) >= i_size_read(inode)) ||' ?

Seems like fs/netfs/read_helper.c currently has the same issue?

>> +		    (pos_in_page == 0 && (pos + len) >= i_size_read(inode))) {
>> +			zero_user_segments(page, 0, pos_in_page,
>> +					   pos_in_page + len, PAGE_SIZE);
>> +			break;
>> +		}

-- 
Andrew W. Elble
Infrastructure Engineer
Information and Technology Services
Rochester Institute of Technology
tel: (585)-475-2411 | aweits@rit.edu
PGP: BFAD 8461 4CCF DC95 DA2C B0EB 965B 082E 863E C912
