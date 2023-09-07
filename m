Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30323796ECA
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Sep 2023 04:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjIGCGM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Sep 2023 22:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbjIGCGL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Sep 2023 22:06:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B6C19A0
        for <ceph-devel@vger.kernel.org>; Wed,  6 Sep 2023 19:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694052321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mAOMVb38ygJCzyd3CkZkt6Zs2GvvOwkto/wEIjVgtqk=;
        b=CGbGLcv3NJZxC9ZrlX6SPtdgO/JWoHWQuV95O2hL0NW9ZzXJ08VFaWRqgrEIecq6a7WLaQ
        2ZaBoMYOm+Jk/IzBrH5eKoVnvljcsb8bR6u9jltSEs9GLRj9zbjxwB/1XTiITxaGlMs7rs
        c9hIqUScI1+zxswL9Yrc/M7u0El4BuE=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-3JTBo0IhMMqCMaS1eCygkA-1; Wed, 06 Sep 2023 22:05:20 -0400
X-MC-Unique: 3JTBo0IhMMqCMaS1eCygkA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-68bf123aca4so641319b3a.1
        for <ceph-devel@vger.kernel.org>; Wed, 06 Sep 2023 19:05:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694052319; x=1694657119;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mAOMVb38ygJCzyd3CkZkt6Zs2GvvOwkto/wEIjVgtqk=;
        b=bXBn4/1k1CvgUqFucsIZO1JUdnEckToz5gz3dm22bXJR6jqRZlyFgCyBo3L64ShaoM
         xF1qDBTNj/Jepsn6uLytaPL0scVYAISqUR49nLbz1k4x3HBPYjC3uJ1kkevSPxeCdNyR
         YSxNr6SEuF+THSJ+VJSNAmKHDLqNdqhjvsW8M6cESTr/DNVoPbYLP6i6tsJEsfbN5CiO
         mNAKhQS1HqimYWSrVVzJbYo38ythhvqiEI5GddSDIPkAAye0cnEN5pEyRQB7MbfZdNcb
         azxkfgz9uCm1nB0676NhXkMWDRFPFzUl7vh9u4+LfD82Rx5F0hnGUG38vzJAsBd9hFCE
         7GKQ==
X-Gm-Message-State: AOJu0YyyHIcf6D2qCBk/g4CqZmGpkupBXVzSIH7qE+2xUf892+9uT5Oa
        DD/7gqJLZ2gvEJT+Ysre3Qfti2AVzDyMLOkDi1kCRtz6y669UrwzXl5JZ6EYq00W/03F/GiNbl1
        CH2hRuVMQOp8NyezjI1nOwaWWDVrBhkda
X-Received: by 2002:a05:6a00:330a:b0:68e:351b:15b8 with SMTP id cq10-20020a056a00330a00b0068e351b15b8mr2921335pfb.12.1694052319283;
        Wed, 06 Sep 2023 19:05:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgKUxRCv4A+/kRhG/J+e0GeGtuuB3J4WO4KxSQX6GjYDq2c0VhRicCTMhAO8JgRFY9Oek7EA==
X-Received: by 2002:a05:6a00:330a:b0:68e:351b:15b8 with SMTP id cq10-20020a056a00330a00b0068e351b15b8mr2921324pfb.12.1694052318974;
        Wed, 06 Sep 2023 19:05:18 -0700 (PDT)
Received: from [10.72.112.114] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d15-20020aa78e4f000000b00682bec0b680sm11470781pfr.89.2023.09.06.19.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Sep 2023 19:05:18 -0700 (PDT)
Message-ID: <3f6b622d-8513-f289-5146-546c1f747e10@redhat.com>
Date:   Thu, 7 Sep 2023 10:05:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: fail the open_by_handle_at() if the dentry is being
 unlinked
Content-Language: en-US
To:     Sebastian Hasler <sebastian.hasler@sec.uni-stuttgart.de>
Cc:     ceph-devel@vger.kernel.org
References: <20220804080624.14768-1-xiubli@redhat.com>
 <e60ea973-d323-1d4d-c03b-0ee4779735c4@sec.uni-stuttgart.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <e60ea973-d323-1d4d-c03b-0ee4779735c4@sec.uni-stuttgart.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/7/23 00:58, Sebastian Hasler wrote:
> While reviewing the implementation of __fh_to_dentry (in the CephFS 
> client), I noticed a possible race condition.
>
> Linux has a syscall linkat(2) which allows, given an open file 
> descriptor, to create a link for the file. So an inode that is 
> unlinked can become linked.
>
> Now the problem: The line ((inode->i_nlink == 0) && 
> !__ceph_is_file_opened(ci)) performs two checks. If, in between those 
> checks, the file goes from the unlinked and open state to the linked 
> and closed state, then we return -ESTALE even though the inode is 
> linked. I don't think this is the intended behavior. I guess this 
> (going from unlinked and open to linked and closed) can happen when a 
> concurrent process calls linkat() and then close().
>
Hi Sebastian,

Thanks for your reporting.

int linkat(int olddirfd, const char *oldpath, int newdirfd, const char 
*newpath, int flags);

BTW, for "an open file descripter", do you mean "olddirfd" ? Because 
"olddirfd" is a dir's open file descripter, how is that possible it can 
become linked again ?

Correct me if I'm misreading it.

Thanks

- Xiubo

