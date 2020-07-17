Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA144223CCE
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jul 2020 15:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgGQNc7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Jul 2020 09:32:59 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25732 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726079AbgGQNc7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 09:32:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594992778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i1q0XIqQS5s4UpdqIs/7/8sbioSQndjr3zmCPN2VuuA=;
        b=DeBSWDz05+d848qiakTtXv82gDjJEbqPiwo6Pn71JZTHAXd8vdrXKGbLsf+c8W1LPGWqWV
        4pSSugM/f/QACiJMxgi9elSfV0OJWnPmqaoAaxvQ3HMcPXolooPZyE3Le4xNypjCNtdXYL
        rxJkkjp6a72gFVQyQ43LEE3JLyUAkBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-a5fIu5aLNPqEjdc3mvHoCw-1; Fri, 17 Jul 2020 09:32:56 -0400
X-MC-Unique: a5fIu5aLNPqEjdc3mvHoCw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8A321800D42;
        Fri, 17 Jul 2020 13:32:54 +0000 (UTC)
Received: from [10.72.12.127] (ovpn-12-127.pek2.redhat.com [10.72.12.127])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94E8419C58;
        Fri, 17 Jul 2020 13:32:52 +0000 (UTC)
Subject: Re: [PATCH] ceph: check the sesion state and return false in case it
 is closed
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, zyan@redhat.com,
        pdonnell@redhat.com, vshankar@redhat.com
References: <20200717132513.8845-1-xiubli@redhat.com>
 <efcd42ccc33c8e4a78ceb3c749e56a952e3989b2.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <cb84ea73-1f27-cb1e-aa4d-bb1c95eb31c0@redhat.com>
Date:   Fri, 17 Jul 2020 21:32:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <efcd42ccc33c8e4a78ceb3c749e56a952e3989b2.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/7/17 21:32, Jeff Layton wrote:
> On Fri, 2020-07-17 at 09:25 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If the session is already in closed state, we should skip it.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 887874f8ad2c..2af773168a0a 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4302,6 +4302,7 @@ bool check_session_state(struct ceph_mds_session *s)
>>   	}
>>   	if (s->s_state == CEPH_MDS_SESSION_NEW ||
>>   	    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
>> +	    s->s_state == CEPH_MDS_SESSION_CLOSED ||
>>   	    s->s_state == CEPH_MDS_SESSION_REJECTED)
>>   		/* this mds is failed or recovering, just wait */
>>   		return false;
> Looks good. I merged this into testing and rebased the metrics patches
> on top.

Thanks Jeff.


> Thanks!


