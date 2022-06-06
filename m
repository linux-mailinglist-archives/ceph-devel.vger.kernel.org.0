Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1339A53EB35
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 19:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbiFFMgz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 08:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237211AbiFFMe7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 08:34:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EFE02AD9BB
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 05:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654518895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nOFPsw6pZ52g697DMqQioGQrb7iSt9R3a7yn63No8CM=;
        b=Et3fx7ayV+ah8+ZiWOuPRpLJRhQRSXSZ2ZY6dYWDtHhlKzcB2WRI3l0Mg2d/F7DxK1d8p5
        oHA33NP54e2Xd6m7eZGSa/NyR5sWSbZ+Sccr6WOGTcnviiFKzq1BAphzprG5anryZD2/j3
        GDlVlgQtjEQzZvlOVr5HSjP++Nwz7CA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-SRxImkjLO3mUQI4tTtPMDA-1; Mon, 06 Jun 2022 08:34:54 -0400
X-MC-Unique: SRxImkjLO3mUQI4tTtPMDA-1
Received: by mail-pj1-f69.google.com with SMTP id g14-20020a17090a128e00b001e882d66615so952728pja.9
        for <ceph-devel@vger.kernel.org>; Mon, 06 Jun 2022 05:34:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=nOFPsw6pZ52g697DMqQioGQrb7iSt9R3a7yn63No8CM=;
        b=vewrFSgBid6wFOD9xc1ienRFvbdaeFXoxONgWWvNm7lFKyYYhZFAd4CUiPmDC9Iu9+
         ejjUf/LWfccAGJEoyFHVJc1HajVJUJuXGC/hU2Uy1m2dMr++dePdsdwWszDWHmT5Xkzf
         U7k4ChdbeO7+2k4Mc9cWGBVxxOdOAf3nlm5ck+so+TAhorSfMy4kK25SLWq/+sI9bigL
         wVkOsUwGV19N5UgrojZnW3yh30rfQP5XQMAr7AMPNZE84uL4Oh0Hme1mH5u7PC8g0JqD
         CyWHhDuMS5lsD1TJ71vcUMgHCA/Rsc+onV+ZeI/f9Fed0SNhSjAjLhhLuvmQDS+lfTKb
         LDtg==
X-Gm-Message-State: AOAM533g6M/sFzHn67DAz9GH5C+QHoHQQArPVpdRIooYaZA8F+YcQS+Q
        4wX30EXB07Nzbz/IQ16FLXD1v51AIWqT+DGUj55E+4STtsoanqArab2GSxN/urrci/9kpvknsKD
        FpFz0G5kaNyL//6v6f8LG/9lHm6UOoU9RoZ9R5/xbpsMYjcokapas+dt3ElcBVLUHludpByY=
X-Received: by 2002:a17:902:ba88:b0:164:1b2d:61b5 with SMTP id k8-20020a170902ba8800b001641b2d61b5mr24219985pls.27.1654518892041;
        Mon, 06 Jun 2022 05:34:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwL6h2ERCeJt6Llh1rRtTgSF0ojWSW1BCuU22GeJ+6bPoaHxQhIXLaeou/FSAvb5BnznFfGyg==
X-Received: by 2002:a17:902:ba88:b0:164:1b2d:61b5 with SMTP id k8-20020a170902ba8800b001641b2d61b5mr24219966pls.27.1654518891727;
        Mon, 06 Jun 2022 05:34:51 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id dw15-20020a17090b094f00b001e307d66123sm10042604pjb.25.2022.06.06.05.34.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 05:34:51 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix the incorrect comment for the ceph_mds_caps
 struct
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220606122425.316004-1-xiubli@redhat.com>
 <660e7d7382715af210af3293942b4f6ada0d4341.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3871eef2-a447-5c4e-a90c-bf50ba677cd2@redhat.com>
Date:   Mon, 6 Jun 2022 20:34:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <660e7d7382715af210af3293942b4f6ada0d4341.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/6/22 8:26 PM, Jeff Layton wrote:
> On Mon, 2022-06-06 at 20:24 +0800, Xiubo Li wrote:
>> The incorrect comment is misleading. Acutally the last members
>> in ceph_mds_caps strcut is a union for none export and export
>> bodies.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   include/linux/ceph/ceph_fs.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
>> index 86bf82dbd8b8..24622ecb9900 100644
>> --- a/include/linux/ceph/ceph_fs.h
>> +++ b/include/linux/ceph/ceph_fs.h
>> @@ -768,7 +768,7 @@ struct ceph_mds_caps {
>>   	__le32 xattr_len;
>>   	__le64 xattr_version;
>>   
>> -	/* filelock */
>> +	/* a union of none export and export bodies. */
> Also confusing :)
>
> I think you mean "a union of non-export and export bodies."

Right. Will fix it :-)

Thanks!

>>   	__le64 size, max_size, truncate_size;
>>   	__le32 truncate_seq;
>>   	struct ceph_timespec mtime, atime, ctime;

