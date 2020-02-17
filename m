Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3551716168A
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Feb 2020 16:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgBQPpe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Feb 2020 10:45:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23611 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729347AbgBQPpe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Feb 2020 10:45:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581954333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OmiYF1ngAklsB+m6e4doH9p6T1Wvyt8D6zHA90f2MYQ=;
        b=c8jVc6CnRU8r109ZZzHB25I4YODds368NLACi/vWOLyshbGQ7Sa8cjEIrof1YvW59nWksP
        ZwnZ8+8yJIksSA345ayhnvX/NpVBvjKBmeT18WW0tIi3kKltSuqxvU4DT8RlxMLwLBahKj
        z45cLvhz25LAicN6CWK0Ej/jXt1m960=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-95DHlzXgOT-a4g1dYh-p2w-1; Mon, 17 Feb 2020 10:45:27 -0500
X-MC-Unique: 95DHlzXgOT-a4g1dYh-p2w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B23A13EA;
        Mon, 17 Feb 2020 15:45:26 +0000 (UTC)
Received: from [10.72.12.166] (ovpn-12-166.pek2.redhat.com [10.72.12.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 398AD60BE1;
        Mon, 17 Feb 2020 15:45:20 +0000 (UTC)
Subject: Re: [PATCH] ceph: add halt mount option support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200216064945.61726-1-xiubli@redhat.com>
 <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ae54de81-f191-d4cd-8d86-d06958946095@redhat.com>
Date:   Mon, 17 Feb 2020 23:45:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/17 21:04, Jeff Layton wrote:
> On Sun, 2020-02-16 at 01:49 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will simulate pulling the power cable situation, which will
>> do:
>>
>> - abort all the inflight osd/mds requests and fail them with -EIO.
>> - reject any new coming osd/mds requests with -EIO.
>> - close all the mds connections directly without doing any clean up
>>    and disable mds sessions recovery routine.
>> - close all the osd connections directly without doing any clean up.
>> - set the msgr as stopped.
>>
>> URL: https://tracker.ceph.com/issues/44044
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> There is no explanation of how to actually _use_ this feature?

 From the tracker's description I am assuming it just will do something 
like testing some features in the cephfs by simulating connections to 
the client node are lost due to some reasons, such as lost power.

>   I assume
> you have to remount the fs with "-o remount,halt" ?

Yeah, right.


> Is it possible to
> reenable the mount as well?

For the "halt", no.

>    If not, why keep the mount around?

I would let the followed umount to continue to do the cleanup.


>   Maybe we
> should consider wiring this in to a new umount2() flag instead?

For the umount2(), it seems have conflicted with the MNT_FORCE, but a 
little different.


>
> This needs much better documentation.
>
> In the past, I've generally done this using iptables. Granted that that
> is difficult with a clustered fs like ceph (given that you potentially
> have to set rules for a lot of addresses), but I wonder whether a scheme
> like that might be more viable in the long run.
>
> Note too that this may have interesting effects when superblocks end up
> being shared between vfsmounts.

Yeah, this is based the superblock, so for the shared vfsmounts, they 
all will be halted at the same time.


>> @@ -4748,7 +4751,12 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
>>   		if (!session)
>>   			continue;
>>   
>> -		if (session->s_state == CEPH_MDS_SESSION_REJECTED)
>> +		/*
>> +		 * when halting the superblock, it will simulate pulling
>> +		 * the power cable, so here close the connection before
>> +		 * doing any cleanup.
>> +		 */
>> +		if (halt || (session->s_state == CEPH_MDS_SESSION_REJECTED))
>>   			__unregister_session(mdsc, session);
> Note that this is not exactly like pulling the power cable. The
> connection will be closed, which will send a FIN to the peer.

Yeah, it is.

I was thinking for the fuse client, if we send a KILL signal, the kernel 
will also help us close the socket fds and send the FIN to the peer ?

If the fuse client works for this case, so will it here.

>> @@ -1115,6 +1117,16 @@ int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl)
>>   }
>>   EXPORT_SYMBOL(ceph_monc_init);
>>   
>> +void ceph_monc_halt(struct ceph_mon_client *monc)
>> +{
>> +	dout("monc halt\n");
>> +
>> +	mutex_lock(&monc->mutex);
>> +	monc->halt = true;
>> +	ceph_con_close(&monc->con);
>> +	mutex_unlock(&monc->mutex);
>> +}
>> +
> The changelog doesn't mention shutting down connections to the mons.

Yeah, I missed it.

Thanks,

BRs

