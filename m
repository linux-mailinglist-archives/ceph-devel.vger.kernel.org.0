Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEC6666A4C
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Jan 2023 05:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbjALEY4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Jan 2023 23:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236401AbjALEXE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Jan 2023 23:23:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9CD5585
        for <ceph-devel@vger.kernel.org>; Wed, 11 Jan 2023 20:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673497344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/2MYjgXd+br5AVgtQ3pqxZZWwDdWNNQ3iDOPFwfgwL4=;
        b=f07Y5sofwBxEi4Oir5X5YN4LjKA50AV/r4Gu2ayYdyuVQIYllTDAN/VIXA+QjAq5zfyMHu
        p9lqnvuiHTGsD6NqXJ83zpg6PitkwPbrx1i01kFQqEahawvrT0jJLoTDLE/RGQrIOXMwwY
        2od5p5uoxXKJm/pW6a0RW9UuxiXwdBA=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-570-KoFg6H7EPISnN4SuREbaRg-1; Wed, 11 Jan 2023 23:22:23 -0500
X-MC-Unique: KoFg6H7EPISnN4SuREbaRg-1
Received: by mail-pg1-f198.google.com with SMTP id w185-20020a6382c2000000b004b1fcf39c18so5511499pgd.13
        for <ceph-devel@vger.kernel.org>; Wed, 11 Jan 2023 20:22:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/2MYjgXd+br5AVgtQ3pqxZZWwDdWNNQ3iDOPFwfgwL4=;
        b=mYSEfL+vwzyHxvjkYsYj/Sw7xs3Z3HXG4jYQyJNWCM9iueDj0+nZdmG4q+T1iEFoFC
         5KM0UQCgRx16KhCruNS7WK7mH0OxJZM5LwkHmzUHiVzGxzU3PrOq/PzD8tpQVs0qdA9t
         GqT0VFs0sbWxSo50IZTKXOMYZMycpshwRnBp91A20iqih6yrpc1XB/8kGhcbWC55Bdu9
         SiIeWSBo3Eer+hsh6BeQPej/xAoawSfXTma2K7RTr9iuvDTxV85ffdhcQxeMPs3IgSZ0
         tOviuPdO0wkp3tLELA+vEfSadbzNP+TR0S6C08LcfAfIVDLCJItJ3QcGBrhBlpZr2+Qd
         XsSA==
X-Gm-Message-State: AFqh2kqnb95kEureyqCAZClStMPNWhSeJLbXRYT+UqUBrQGkikgnNLz9
        /dowmiN3Jw+Hv/Y97mhcOpUYKtVvtw6O2S8nw6jEkfuq0tliam2oOhlKc9kpDpgdY60Ox6jJ7pY
        d55Ip4MoOlJLjMEmMXkjqiw==
X-Received: by 2002:a17:902:978f:b0:193:3989:b62 with SMTP id q15-20020a170902978f00b0019339890b62mr12470042plp.67.1673497342228;
        Wed, 11 Jan 2023 20:22:22 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv4q+ZIi7PTOC9n7UagFkQ8ajXpfNs0pXzGbZFV/W+jKJqogNdEl8jnWfHQnuNyNt1fjkzYVQ==
X-Received: by 2002:a17:902:978f:b0:193:3989:b62 with SMTP id q15-20020a170902978f00b0019339890b62mr12470030plp.67.1673497341988;
        Wed, 11 Jan 2023 20:22:21 -0800 (PST)
Received: from [10.72.13.255] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b00186b69157ecsm10950621pln.202.2023.01.11.20.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 20:22:21 -0800 (PST)
Message-ID: <371e3c03-e436-2be4-8755-8387370158f5@redhat.com>
Date:   Thu, 12 Jan 2023 12:22:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] ceph: fix double free for req when failing to allocate
 sparse ext map
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, vshankar@redhat.com
References: <20230111011403.570964-1-xiubli@redhat.com>
 <CAOi1vP-Q48xUJNAn37DF2Ud+tVFamxdZuQgJ9VDNH_GmX+pwyw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-Q48xUJNAn37DF2Ud+tVFamxdZuQgJ9VDNH_GmX+pwyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/01/2023 20:22, Ilya Dryomov wrote:
> On Wed, Jan 11, 2023 at 2:14 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Introduced by commit d1f436736924 ("ceph: add new mount option to enable
>> sparse reads") and will fold this into the above commit since it's
>> still in the testing branch.
>>
>> Reported-by: Ilya Dryomov <idryomov@gmail.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 17758cb607ec..3561c95d7e23 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -351,10 +351,8 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>>
>>          if (sparse) {
>>                  err = ceph_alloc_sparse_ext_map(&req->r_ops[0]);
>> -               if (err) {
>> -                       ceph_osdc_put_request(req);
>> +               if (err)
>>                          goto out;
>> -               }
>>          }
>>
>>          dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
>> --
>> 2.39.0
>>
> Hi Xiubo,
>
> Looks good, let's fold this into that commit since it's still testing
> branch material.

Yeah, sure will do.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

