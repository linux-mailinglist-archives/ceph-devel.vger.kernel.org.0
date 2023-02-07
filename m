Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0BCE68CECE
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Feb 2023 06:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjBGFUL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Feb 2023 00:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjBGFUK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Feb 2023 00:20:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8553A1EBC5
        for <ceph-devel@vger.kernel.org>; Mon,  6 Feb 2023 21:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675747158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nEW85GxQFrhXYgdvh4Bl0cREPlgoksar81mS26jUg0k=;
        b=GqZqdsUuCRMCc0/bqnV7TZaRtIw9vlCC5kQnYwAKeXXViZtboBnCoJsPrPtRlTicbejkYj
        XrvC3D1fzqNOXQ1IPkWBLt4YH8VDKD+JiXYHmSe7AWCQBNtPMA9Mp26/Q0ty7+thDF3Jv4
        CENUc7UDxYsRcf8C4fwk+UEbhJXcGAI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-616-H9fwsyqqPEqw8nznudr0tQ-1; Tue, 07 Feb 2023 00:19:15 -0500
X-MC-Unique: H9fwsyqqPEqw8nznudr0tQ-1
Received: by mail-pj1-f71.google.com with SMTP id bk3-20020a17090b080300b0023098d62104so2559151pjb.7
        for <ceph-devel@vger.kernel.org>; Mon, 06 Feb 2023 21:19:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nEW85GxQFrhXYgdvh4Bl0cREPlgoksar81mS26jUg0k=;
        b=XFmZDc7i2MqZviQEjr7mdiTukfrd1/IULZU2R6UW5v4nvVV2rAOOgsfRSvMmaNaOZi
         AdPOK9oo0SSwlVM5kJOR/Z3INKRrwJQE0Dcd+Go7r+asdghUyuz1y43/lPxVisuNpewJ
         VQJyJpQEgTmGG6U5eP7rfgE1Nk9q8Zngq0bemOBAqpwYNqcJZjKNQM4sVJ3sEGHey0w7
         iz48dIIWW77BVHhBNYrF7nUGzkw+7tKVMRkeBPkPwCZ0T4GMJedc1cs7VziLk/R82Tqx
         iox00hjgm5QN0/fxnGPK88qmSP63pmEv1t8wZhtQ0xd4+iXEAgZzA/kOCOFfCXHHN07X
         j60Q==
X-Gm-Message-State: AO0yUKVI+0jvIRE0wXSH0X3K+wC3AfQ03XBeqUD5lT+yUiKUCltiHUQg
        YgqALhBJICWo5uSk0dk3mcP27ti0xVYgZvK04m2NBoJQCzkHNshTDqkeitM7+jh3RUFy3BI9lT6
        1b9RMCDhCRtvp5htx4LMsmA==
X-Received: by 2002:a05:6a20:441b:b0:bc:a334:abc0 with SMTP id ce27-20020a056a20441b00b000bca334abc0mr2820245pzb.21.1675747154457;
        Mon, 06 Feb 2023 21:19:14 -0800 (PST)
X-Google-Smtp-Source: AK7set/th2p4iqt/omvgRsPbUuqBrBuibdm9ePjjfU2fkXnrEVjE7jmpfpprJI60MxxFqcSR7SztQQ==
X-Received: by 2002:a05:6a20:441b:b0:bc:a334:abc0 with SMTP id ce27-20020a056a20441b00b000bca334abc0mr2820220pzb.21.1675747154223;
        Mon, 06 Feb 2023 21:19:14 -0800 (PST)
Received: from [10.72.13.183] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g24-20020aa78758000000b0058d9058fe8asm8101517pfo.103.2023.02.06.21.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 21:19:13 -0800 (PST)
Message-ID: <f31e08f5-972b-f29c-926a-2586863965f5@redhat.com>
Date:   Tue, 7 Feb 2023 13:19:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] ceph: flush cap release on session flush
Content-Language: en-US
To:     Venky Shankar <vshankar@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, lhenriques@suse.de, stable@kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
References: <20230207050452.403436-1-xiubli@redhat.com>
 <CACPzV1nrtsfrxJtMxANuaSPbWo5TbQ8roqopxL+VVeUpYOh=3A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1nrtsfrxJtMxANuaSPbWo5TbQ8roqopxL+VVeUpYOh=3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 07/02/2023 13:16, Venky Shankar wrote:
> On Tue, Feb 7, 2023 at 10:35 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> MDS expects the completed cap release prior to responding to the
>> session flush for cache drop.
>>
>> Cc: <stable@kernel.org>
>> URL: http://tracker.ceph.com/issues/38009
>> Cc: Patrick Donnelly <pdonnell@redhat.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 3c9d3f609e7f..51366bd053de 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4039,6 +4039,12 @@ static void handle_session(struct ceph_mds_session *session,
>>                  break;
>>
>>          case CEPH_SESSION_FLUSHMSG:
>> +               /* flush cap release */
>> +               spin_lock(&session->s_cap_lock);
>> +               if (session->s_num_cap_releases)
>> +                       ceph_flush_cap_releases(mdsc, session);
>> +               spin_unlock(&session->s_cap_lock);
>> +
>>                  send_flushmsg_ack(mdsc, session, seq);
>>                  break;
> Ugh. kclient never flushed cap releases o_O

Yeah, I think this was missed before.

> LGTM.
>
> Reviewed-by: Venky Shankar <vshankar@redhat.com>

Thanks Venky.

>> --
>> 2.31.1
>>
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

