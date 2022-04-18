Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89E2504EFA
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 12:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237796AbiDRKoh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 06:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237783AbiDRKof (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 06:44:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88F3919C1F
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650278514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dK6etTl+z7wZZwjuebSMVWR61LTMcdAPtxptjKy1qnw=;
        b=gGgEjCi9ke8ex0y8h1ojBRy24b7MIALDdTd+L1O+XNMe5qO51SNL3KsR2GQCuRn+bbPT/w
        TVqlO+SrlasiTJI8VLKvQjM1Y1cL9Tb/EwxjuRR0ubBrWdgVnxq5UmrOqpv260a5p69vC2
        Dtq5qe5KKZ3Z1/pX/IoLQGar/+yJFbU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-AAndNRnYOFSGKuOWuFjvzw-1; Mon, 18 Apr 2022 06:41:53 -0400
X-MC-Unique: AAndNRnYOFSGKuOWuFjvzw-1
Received: by mail-pj1-f71.google.com with SMTP id b8-20020a17090a488800b001cb7eb98cbfso11969088pjh.9
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dK6etTl+z7wZZwjuebSMVWR61LTMcdAPtxptjKy1qnw=;
        b=lAbhUfPNFtWB5Jb+6YqzGYfESQJFssP3EEmjYAyFdLQAwOjeusG0ZJAN++22lAhu00
         /zrmJDlpgCYlakNOkeGpC36HS3iWpPmLlknhMT4yQ+8g+kqBvD/2hR8EuPyNxXHuh0v0
         LQWMiEweYlKHYg7+w6vcpDcGKDd8JFxIzsITsAX9wppH2TXhbTx561LBeLQihg2F61Aw
         uucBxh1B3GIjD2ailFbJAdGnnHu/Me7R8AMx0GN0T3q0Wqrz9lRMWvdxS3MqGBnsQiWI
         t8LNx6N2AdSGJRto8BoVvrM16hrAnoTUmKY01AQB36RjFnlxKENdcAK13d8R7m71Vc4T
         wpRA==
X-Gm-Message-State: AOAM533DkSf43pEqh/m4u5PJON86Nq/GNLMS9tsVjUMYo4rtf/EHHZtD
        1WOEI2bXTopeG+z1/QZmEjV/sDqcegFy02Wf8FZaLcOlZiTVVicrqlt/Nu0eaF9YH9hvMj4RakT
        VSx0zA5l5xjiexR0qmesSSGNtjR+SABF0PZ3K0v6BK0k9khbQqxWcxVJ7+Rg4pnGE5TmyExE=
X-Received: by 2002:a17:90a:aa98:b0:1b8:5adb:e35f with SMTP id l24-20020a17090aaa9800b001b85adbe35fmr12431811pjq.192.1650278512097;
        Mon, 18 Apr 2022 03:41:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1HreKvFr7/lNIxszU8Xu1+fK8NoOGLosrf7KuzETFrOeu6rUexwdtgv4uQc8RdtVsWGLw7w==
X-Received: by 2002:a17:90a:aa98:b0:1b8:5adb:e35f with SMTP id l24-20020a17090aaa9800b001b85adbe35fmr12431784pjq.192.1650278511775;
        Mon, 18 Apr 2022 03:41:51 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cr12-20020a056a000f0c00b005082b3e087bsm11459327pfb.108.2022.04.18.03.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 03:41:51 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: flush the mdlog for filesystem sync
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220414054512.386293-1-xiubli@redhat.com>
 <fd9596a8dc07508588fe8ac1372888eba4f8d82f.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <aeba5063-a0e5-f9d5-ccb2-a92be39c51bd@redhat.com>
Date:   Mon, 18 Apr 2022 18:41:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <fd9596a8dc07508588fe8ac1372888eba4f8d82f.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/18/22 6:25 PM, Jeff Layton wrote:
> On Thu, 2022-04-14 at 13:45 +0800, Xiubo Li wrote:
>> Before waiting for a request's safe reply, we will send the mdlog
>> flush request to the relevant MDS. And this will also flush the
>> mdlog for all the other unsafe requests in the same session, so
>> we can record the last session and no need to flush mdlog again
>> in the next loop. But there still have cases that it may send the
>> mdlog flush requst twice or more, but that should be not often.
>>
>> URL: https://tracker.ceph.com/issues/55284
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - Fixed possible NULL pointer dereference for the req->r_session
>>
>>
>>   fs/ceph/mds_client.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 0da85c9ce73a..4aaa7b14136e 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -5098,6 +5098,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>>   static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
>>   {
>>   	struct ceph_mds_request *req = NULL, *nextreq;
>> +	struct ceph_mds_session *last_session = NULL, *s;
>>   	struct rb_node *n;
>>   
>>   	mutex_lock(&mdsc->mutex);
>> @@ -5117,6 +5118,15 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
>>   			ceph_mdsc_get_request(req);
>>   			if (nextreq)
>>   				ceph_mdsc_get_request(nextreq);
>> +
>> +			/* send flush mdlog request to MDS */
>> +			s = req->r_session;
>> +			if (s && last_session != s) {
>> +				send_flush_mdlog(s);
>> +				ceph_put_mds_session(last_session);
>> +				last_session = ceph_get_mds_session(s);
>> +			}
>> +
>>   			mutex_unlock(&mdsc->mutex);
>>   			dout("wait_unsafe_requests  wait on %llu (want %llu)\n",
>>   			     req->r_tid, want_tid);
>> @@ -5135,6 +5145,7 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
>>   		req = nextreq;
>>   	}
>>   	mutex_unlock(&mdsc->mutex);
>> +	ceph_put_mds_session(last_session);
>>   	dout("wait_unsafe_requests done\n");
>>   }
>>   
> Looks reasonable. My only minor nit is that "wait_unsafe_requests" is
> not really descriptive of this function anymore since you're not just
> waiting on requests anymore, but also sending mdlog flush requests.
>
> The sync handling in this code is a bit of a mess too. We have
> unsafe_request_wait which is called from the fsync codepath, and then we
> also have wait_unsafe_requests which is called from ceph_sync_fs. I
> suspect they do enough of the same things that those could be combined.

I tried and It was hard to combine them IMO.

The fsync() will iterate the "ci->i_unsafe_iops" and 
"ci->i_unsafe_dirops" first and get all the possible sessions, and then 
will send flush mdlog requests to them all.

In the ceph_sync_fs() it needs to iterate the global 
"mdsc->request_tree" instead.

-- Xiubo


> So, I'll give my ACK on this, but wouldn't mind seeing some other
> cleanup in this area.
>
> Acked-by: Jeff Layton <jlayton@kernel.org>
>

