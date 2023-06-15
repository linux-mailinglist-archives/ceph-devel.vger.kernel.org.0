Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543B37318FD
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jun 2023 14:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240457AbjFOMaC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Jun 2023 08:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239458AbjFOM37 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Jun 2023 08:29:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC788129
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 05:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686832151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=miKGhTsa1C617Jf+rAPO8YcjvbVy2XjmmKexewlCMig=;
        b=JZ19k4HHyj9aynwJW7ILq9EPCnZqEXMdkyA8+9e2MnpzAwu2LkM5FzIkOf1pUa9mpDx06j
        ryML0CXasWRnNuUoOW45g5BYl1AS3GrhXJJsq2i/6umc9uPMjtTsrF2hq8xiROsW4QNzpj
        zcQA9W1K9pg58PzpzFOCngwjkIq17Gg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-hFHDiW0mPSifponFbjlZJQ-1; Thu, 15 Jun 2023 08:29:10 -0400
X-MC-Unique: hFHDiW0mPSifponFbjlZJQ-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1b3e18add74so20465495ad.1
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 05:29:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686832149; x=1689424149;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=miKGhTsa1C617Jf+rAPO8YcjvbVy2XjmmKexewlCMig=;
        b=IZg4c7YkAGkZYpvA3WpzMmV2VbHJLjGG8RNo4gyjsJ8v3pu0EOUYoiamRiAPMWFIIi
         +Rpj69shwc7QYokHfLqyI6mdyXJU4ox3qSf1lJU97bXIYQCvPP/gDsCxeaGQh3mH3eko
         XtHfLR+88MMkaSeO4jg2SQ4J4H5XyH7gaBUD7gjXJc+1I7+H5udSfhiI0xY73F945adT
         5ob9xUwqCU8hEQoqR/Ity6WEBOYu/gd7lxcC5B3FV+lSbq4c1ZI6+INupjLfGx0Js452
         0nc6aUL06ppZmXajXF1nwVCBPyaUuqCo2J0Z1fqbZ2mVEoRO9ZfDV4Ix5czL/KtopAyd
         zaTQ==
X-Gm-Message-State: AC+VfDwveYmWqYb8HrZPcETjVHTAYTLlH/VKaG1iCPQopunpJfktZOig
        BYy3IECF0ZPVjQXOLDeInvVyoNGyooXy86cznk1peWaCLUXAWQSZhfD6oE5xFMzt4fT09/fQOky
        ldz3PcIT+5y3YKJO17IyfMQ==
X-Received: by 2002:a17:902:ecc9:b0:1b0:fe9:e57e with SMTP id a9-20020a170902ecc900b001b00fe9e57emr16332664plh.0.1686832149261;
        Thu, 15 Jun 2023 05:29:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ47UwUMIaeKjeei4hpwO38mx1dbD0wAapGYqH6wtjkzhQTmhZv/MA3mxt0UYN8TaPs+w9oB1A==
X-Received: by 2002:a17:902:ecc9:b0:1b0:fe9:e57e with SMTP id a9-20020a170902ecc900b001b00fe9e57emr16332648plh.0.1686832149003;
        Thu, 15 Jun 2023 05:29:09 -0700 (PDT)
Received: from [10.72.12.155] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w5-20020a1709029a8500b001ab0a30c895sm13953037plp.202.2023.06.15.05.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 05:29:08 -0700 (PDT)
Message-ID: <bb20aebe-e598-9212-1533-c777ea89948a@redhat.com>
Date:   Thu, 15 Jun 2023 20:29:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 00/14] ceph: support idmapped mounts
Content-Language: en-US
From:   Xiubo Li <xiubli@redhat.com>
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        Christian Brauner <brauner@kernel.org>, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
 <f3864ed6-8c97-8a7a-f268-dab29eb2fb21@redhat.com>
 <CAEivzxcRsHveuW3nrPnSBK6_2-eT4XPvza3kN2oogvnbVXBKvQ@mail.gmail.com>
 <20230609-alufolie-gezaubert-f18ef17cda12@brauner>
 <CAEivzxc_LW6mTKjk46WivrisnnmVQs0UnRrh6p0KxhqyXrErBQ@mail.gmail.com>
 <ac1c6817-9838-fcf3-edc8-224ff85691e0@redhat.com>
 <CAJ4mKGby71qfb3gd696XH3AazeR0Qc_VGYupMznRH3Piky+VGA@mail.gmail.com>
 <977d8133-a55f-0667-dc12-aa6fd7d8c3e4@redhat.com>
 <CAEivzxcr99sERxZX17rZ5jW9YSzAWYvAjOOhBH+FqRoso2=yng@mail.gmail.com>
 <626175e2-ee91-0f1a-9e5d-e506aea366fa@redhat.com>
In-Reply-To: <626175e2-ee91-0f1a-9e5d-e506aea366fa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

[...]

 > > >
 > > > I thought about this too and came to the same conclusion, that 
UID/GID
 > > > based
 > > > restriction can be applied dynamically, so detecting it on mount-time
 > > > helps not so much.
 > > >
 > > For this you please raise one PR to ceph first to support this, and in
 > > the PR we can discuss more for the MDS auth caps. And after the PR
 > > getting merged then in this patch series you need to check the
 > > corresponding option or flag to determine whether could the idmap
 > > mounting succeed.
 >
 > I'm sorry but I don't understand what we want to support here. Do we 
want to
 > add some new ceph request that allows to check if UID/GID-based
 > permissions are applied for
 > a particular ceph client user?

IMO we should prevent users to set UID/GID-based MDS auth caps from ceph 
side. And users should know what has happened.

Once users want to support the idmap mounts they should know that the 
MDS auth caps won't work anymore.

Thanks

- Xiubo

