Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD4D2AF1FC
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 14:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgKKNXx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Nov 2020 08:23:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:57776 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgKKNXw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 08:23:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B00D2AD45;
        Wed, 11 Nov 2020 13:23:51 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 38d5158b;
        Wed, 11 Nov 2020 13:24:03 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, pdonnell@redhat.com
Subject: Re: [PATCH v2] ceph: ensure we have Fs caps when fetching dir link
 count
References: <20201110163052.482965-1-jlayton@kernel.org>
        <877dqsfd9m.fsf@suse.de>
        <389065486cd51a9ceebe6edf9d1b3ea84129a62d.camel@kernel.org>
Date:   Wed, 11 Nov 2020 13:24:03 +0000
In-Reply-To: <389065486cd51a9ceebe6edf9d1b3ea84129a62d.camel@kernel.org> (Jeff
        Layton's message of "Wed, 11 Nov 2020 07:53:43 -0500")
Message-ID: <87tutwdo24.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Wed, 2020-11-11 at 09:34 +0000, Luis Henriques wrote:
>> Jeff Layton <jlayton@kernel.org> writes:
>> 
>> > The link count for a directory is defined as inode->i_subdirs + 2,
>> > (for "." and ".."). i_subdirs is only populated when Fs caps are held.
>> > Ensure we grab Fs caps when fetching the link count for a directory.
>> > 
>> 
>> Maybe this would be worth a stable@ tag too...?
>> 
>> Cheers,
>
> Usually I reserve stable tags for "real problems" (oopses, etc), that we
> want to send to mainline immediately. This is just a subtle case where
> the link count in a stat() call ends up looking wrong.
>
> If someone wants to make a case for stable, I'm willing to listen, but
> this one doesn't seem worth it.

Ok, fair enough.

Cheers,
-- 
Luis
