Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166F724479F
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Aug 2020 12:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHNKDc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Aug 2020 06:03:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:43442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgHNKDc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 14 Aug 2020 06:03:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3E244AD1B;
        Fri, 14 Aug 2020 10:03:53 +0000 (UTC)
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id fc9ad6f5;
        Fri, 14 Aug 2020 10:03:28 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ceph: remove unnecessary return in switch statement
References: <20200814093822.GA293898@suse.de>
        <a1a68d9a887148ae9a80ca103d112e6b@AcuMS.aculab.com>
Date:   Fri, 14 Aug 2020 11:03:28 +0100
In-Reply-To: <a1a68d9a887148ae9a80ca103d112e6b@AcuMS.aculab.com> (David
        Laight's message of "Fri, 14 Aug 2020 09:52:38 +0000")
Message-ID: <877du1h7db.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

David Laight <David.Laight@ACULAB.COM> writes:

> From: Luis Henriques
>> Sent: 14 August 2020 10:38
>> 
>> Since there's a return immediately after the 'break', there's no need for
>> this extra 'return' in the S_IFDIR case.
>> 
>> Signed-off-by: Luis Henriques <lhenriques@suse.de>
>> ---
>>  fs/ceph/file.c | 2 --
>>  1 file changed, 2 deletions(-)
>> 
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index d51c3f2fdca0..04ab99c0223a 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -256,8 +256,6 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
>>  	case S_IFDIR:
>>  		ret = ceph_init_file_info(inode, file, fmode,
>>  						S_ISDIR(inode->i_mode));
>> -		if (ret)
>> -			return ret;
>>  		break;
>> 
>>  	case S_IFLNK:
>
> I'd move the other way and just do:
> 		return ceph_init_file_info(...);

Sure, that would work too, although my preference would be to have a
single function exit point.  But I'll leave that decision to Jeff :-)

Cheers,
-- 
Luis

>
> 	David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
