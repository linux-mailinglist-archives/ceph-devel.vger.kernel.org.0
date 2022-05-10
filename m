Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420D5520F4F
	for <lists+ceph-devel@lfdr.de>; Tue, 10 May 2022 10:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbiEJIEe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 May 2022 04:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbiEJIEb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 May 2022 04:04:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E5442532CE
        for <ceph-devel@vger.kernel.org>; Tue, 10 May 2022 01:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652169634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h3N81JmxkZihiFR/823UdinPS1d7jqbrlMssUqZWLoc=;
        b=hmNDJLIT5/E8ogEzwF5aRnVRtq+/PUc4jsTdiUtxn4dLWmUAXIaw1qS1xjPcOE+ZNSUXGC
        9436iDhN98J57KMZGLNElCREsLNm7L6oEgZz5cVccAwV2oE40EErBHNnqXl5jwrt/aOmTp
        GNw/vd35FDAFFbIN7GllqFvB5Wj2YDE=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-aoP5P4k4NlGPl-PeJofPzw-1; Tue, 10 May 2022 04:00:33 -0400
X-MC-Unique: aoP5P4k4NlGPl-PeJofPzw-1
Received: by mail-pg1-f199.google.com with SMTP id j187-20020a638bc4000000b003c1922b0f1bso8573861pge.3
        for <ceph-devel@vger.kernel.org>; Tue, 10 May 2022 01:00:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=h3N81JmxkZihiFR/823UdinPS1d7jqbrlMssUqZWLoc=;
        b=hDG3jriN+iyHBlB0mQXLz5gHe05qI3FXW7qIqdlRXd+vXXxVPs4BnGC6A3q8g50ow2
         j8lu5nctsLYq252+NGyEcWiEicfOe17o539+A+RppRJRdfDI+SQsA72GMTd8PEKw6oK5
         NnUJEeOiG57q+FrVoQ1Y+HZj0f7JYkviPf27mMJ1aXn+ldOPGM8uU3DmnzUBLXQ+RYEQ
         9oTjwqA9jZOtc1k6rv/fZy5BD0WOp4EM/YKmbwcpBNY2oelcE2UpM3um30//tlUqdUpw
         990A5sg4CcJftZCMj+QyNVVQnwk5UeMnxvfbbW5xuo7v5UCC6vKAHovVihvKhWseuxUW
         6cZA==
X-Gm-Message-State: AOAM530xByl1MhNoxeovprLtzW66q+4zYrduYEvA2XwfxqF8YuXejXHY
        0ty0gFGGzHxv1lnmchGurifKjUD2aYymQwrrvp2XidrEQ+ZHylecRQDYee+EcQl+thnMS96Gi7g
        xh/en9W4LPzXfO/1ZOWGPyAFIznGCl1gWAqdIVA7EsFDKOnUL7KEGuvXVA+qOnVUDErSl10I=
X-Received: by 2002:a05:6a00:1c5c:b0:505:7469:134a with SMTP id s28-20020a056a001c5c00b005057469134amr19291475pfw.16.1652169631918;
        Tue, 10 May 2022 01:00:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJHqPj/s0Y5M12u4YARVT62yyvpPxALxD2kGZwt80aAKL1bOiqgImlAZnKtTE+LoPSmhV3Pg==
X-Received: by 2002:a05:6a00:1c5c:b0:505:7469:134a with SMTP id s28-20020a056a001c5c00b005057469134amr19291448pfw.16.1652169631551;
        Tue, 10 May 2022 01:00:31 -0700 (PDT)
Received: from [10.72.13.130] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bf6-20020a170902b90600b0015e8d4eb276sm1256272plb.192.2022.05.10.01.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 01:00:30 -0700 (PDT)
Subject: Re: [PATCH v3] ceph: switch to VM_BUG_ON_FOLIO and continue the loop
 for none write op
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Venky Shankar <vshankar@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20220506152243.497173-1-xiubli@redhat.com>
 <CAOi1vP9GHbVDTc3pM2x9HMYmeHWzN5SseESXcczEixxC1XL=Ug@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ab685129-1d79-cc69-5f7e-8ef36b56d48f@redhat.com>
Date:   Tue, 10 May 2022 16:00:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9GHbVDTc3pM2x9HMYmeHWzN5SseESXcczEixxC1XL=Ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/10/22 3:58 PM, Ilya Dryomov wrote:
> On Fri, May 6, 2022 at 5:22 PM Xiubo Li <xiubli@redhat.com> wrote:
>> Use the VM_BUG_ON_FOLIO macro to get more infomation when we hit
>> the BUG_ON, and continue the loop when seeing the incorrect none
>> write opcode in writepages_finish().
>>
>> URL: https://tracker.ceph.com/issues/55421
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 04a6c3f02f0c..63b7430e1ce6 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -85,7 +85,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>>          if (folio_test_dirty(folio)) {
>>                  dout("%p dirty_folio %p idx %lu -- already dirty\n",
>>                       mapping->host, folio, folio->index);
>> -               BUG_ON(!folio_get_private(folio));
>> +               VM_BUG_ON_FOLIO(!folio_get_private(folio), folio);
>>                  return false;
>>          }
>>
>> @@ -122,7 +122,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>>           * Reference snap context in folio->private.  Also set
>>           * PagePrivate so that we get invalidate_folio callback.
>>           */
>> -       BUG_ON(folio_get_private(folio));
>> +       VM_BUG_ON_FOLIO(folio_get_private(folio), folio);
>>          folio_attach_private(folio, snapc);
>>
>>          return ceph_fscache_dirty_folio(mapping, folio);
>> @@ -733,8 +733,11 @@ static void writepages_finish(struct ceph_osd_request *req)
>>
>>          /* clean all pages */
>>          for (i = 0; i < req->r_num_ops; i++) {
>> -               if (req->r_ops[i].op != CEPH_OSD_OP_WRITE)
>> +               if (req->r_ops[i].op != CEPH_OSD_OP_WRITE) {
>> +                       pr_warn("%s incorrect op %d req %p index %d tid %llu\n",
>> +                               __func__, req->r_ops[i].op, req, i, req->r_tid);
>>                          break;
>> +               }
>>
>>                  osd_data = osd_req_op_extent_osd_data(req, i);
>>                  BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);
>> --
>> 2.36.0.rc1
>>
> Hi Xiubo,
>
> Since in this revision the loop isn't actually continued, the only
> substantive change left seems to be the addition of pr_warn before the
> break.  I went ahead and folded this patch into "ceph: check folio
> PG_private bit instead of folio->private" (which is now queued up for
> 5.18-rc).

Sure, Ilya.

Thanks!

-- Xiubo

>
> Thanks,
>
>                  Ilya
>

