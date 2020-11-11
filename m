Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15D62AF3AC
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 15:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgKKOes convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Wed, 11 Nov 2020 09:34:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:46672 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgKKOes (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 09:34:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1412CABD1;
        Wed, 11 Nov 2020 14:34:47 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 7c7abba8;
        Wed, 11 Nov 2020 14:34:59 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Subject: Re: [RFC PATCH] ceph: guard against __ceph_remove_cap races
References: <20191212173159.35013-1-jlayton@kernel.org>
        <CAAM7YAmquOg5ESMAMa5y0gGAR-UAivYF8m+nqrJNmK=SzG6+wA@mail.gmail.com>
        <64d5a16d920098122144e0df8e03df0cadfb2784.camel@kernel.org>
        <871rh0f8w3.fsf@suse.de>
        <05512d3c3bf95eb551ea8ae4982b180f8c4deb0d.camel@kernel.org>
        <87mtzodluu.fsf@suse.de>
        <49f1ee2a409c8f51594ada0605349d3b782d106b.camel@kernel.org>
Date:   Wed, 11 Nov 2020 14:34:58 +0000
In-Reply-To: <49f1ee2a409c8f51594ada0605349d3b782d106b.camel@kernel.org> (Jeff
        Layton's message of "Wed, 11 Nov 2020 09:24:33 -0500")
Message-ID: <87a6vodkrx.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Wed, 2020-11-11 at 14:11 +0000, Luis Henriques wrote:
>> 
>> 
>
> It think this looks reasonable. Minor nits below:
>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index ded4229c314a..917dfaf0bd01 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1140,12 +1140,17 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>>  {
>>         struct ceph_mds_session *session = cap->session;
>>         struct ceph_inode_info *ci = cap->ci;
>> -       struct ceph_mds_client *mdsc =
>> -               ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
>> +       struct ceph_mds_client *mdsc;
>> +
>
> nit: remove the above newline
>
>>         int removed = 0;
>>  
>
> Maybe add a comment here to the effect that a NULL cap->ci indicates
> that the remove has already been done?
>
>> +       if (!ci)
>> +               return;
>> +
>>         dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
>>  
>> +       mdsc = ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
>> +
>
> There's a ceph_inode_to_client helper now that may make this a bit more
> readable.
>
>>         /* remove from inode's cap rbtree, and clear auth cap */
>>         rb_erase(&cap->ci_node, &ci->i_caps);
>>         if (ci->i_auth_cap == cap) {

Thanks Jeff.  I'll re-post this soon with your suggestions.  I just want
to run some more local tests to make sure things aren't breaking with this
change.

Cheers,
-- 
Luis
