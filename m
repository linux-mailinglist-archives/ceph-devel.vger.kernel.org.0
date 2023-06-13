Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420E972DDA8
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 11:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240830AbjFMJ2b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 05:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240803AbjFMJ2X (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 05:28:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1AFB7
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 02:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686648459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnwgamvqpc4MiEQa0vKqHK4W1dU6qciS/Fb1KhddW8c=;
        b=jO/z+gWQQT30Z6H92ooZ0eYnIT/LI/icSvLhDzp2xRFsHjq42jQaE+vq/3eE9/I04D0ze/
        xWysljs6p3bbxjm+Q+8ceMWLZQ9LeTd2KjEiRBVbV45FNoPLvEd7oF7zjWECe8Q1TbM0G9
        L2qTjwTKwpAAv21h0jEMMfHmhku0xPE=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-DyFZUCypNd6HpMiHhF5ekQ-1; Tue, 13 Jun 2023 05:27:36 -0400
X-MC-Unique: DyFZUCypNd6HpMiHhF5ekQ-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-564fb1018bcso84472697b3.0
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 02:27:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686648456; x=1689240456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dnwgamvqpc4MiEQa0vKqHK4W1dU6qciS/Fb1KhddW8c=;
        b=FdBDLGZxCZqusga5KNPY9twlG8iOrl549O1QJ7qFJIqbMZVm2qEeFh2gBxL5nQlgNb
         xGXPB4KO10IEFdEoLlkUnxOn8Qr+DeoXoz9fu8mz/uGNA3Vibu6d32OFgiA4+BsMYCYQ
         +2CPzucIm4KDZH42eNa1/qB6fOj6wc98cMkJfqcEv/jeGNQ24H2f1sxTsUXYq/v0m7Pa
         ao0tBRpceygGRBjP/k91uKyyYGTjTqDEK8C2EX4cP5izmp7gDzilOirU8ZT0lip9EzGc
         fX2LsrNzlGa6rUSEc0QR3OrhSVcZ49+Kp2GlNxyZOluI3qvYLGFzspBQmH1/5yL7/jqx
         4oEA==
X-Gm-Message-State: AC+VfDwEsJvyb1WMxnB6ym0/yA3mwEEk1RyIsVHP2Lw/049qVP3D2ohX
        bQ2ZvInSQqX4jom6CtpFABvPYHL7vS0W4PTtCKVgpCHd6dl7wE2r++GKkLHK7eEP8zJgKepqFK6
        hju0jLlR+iwcqCI+jhgfk/A==
X-Received: by 2002:a81:6c0c:0:b0:56d:297e:7c8c with SMTP id h12-20020a816c0c000000b0056d297e7c8cmr1253474ywc.8.1686648456214;
        Tue, 13 Jun 2023 02:27:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6DWVXwiQix11kWJg3+SKUxTRxo+cczcO3dxqfHyI9dZgXhLp6gJM6Ihkm4VwtWJvttqz1GEA==
X-Received: by 2002:a81:6c0c:0:b0:56d:297e:7c8c with SMTP id h12-20020a816c0c000000b0056d297e7c8cmr1253460ywc.8.1686648455927;
        Tue, 13 Jun 2023 02:27:35 -0700 (PDT)
Received: from [10.72.12.155] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id mq16-20020a17090b381000b00259980d373dsm10787986pjb.1.2023.06.13.02.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 02:27:35 -0700 (PDT)
Message-ID: <2a947e0d-5773-2032-c054-d99eeace1ddc@redhat.com>
Date:   Tue, 13 Jun 2023 17:27:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 1/6] ceph: add the *_client debug macros support
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, khiremat@redhat.com, mchangir@redhat.com,
        pdonnell@redhat.com
References: <20230612114359.220895-1-xiubli@redhat.com>
 <20230612114359.220895-2-xiubli@redhat.com>
 <CAOi1vP-u-UR-jd=ALxJTwjq4AJpQ7_=chMqwwBmrxsyQqXCqVQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-u-UR-jd=ALxJTwjq4AJpQ7_=chMqwwBmrxsyQqXCqVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/13/23 16:39, Ilya Dryomov wrote:
> On Mon, Jun 12, 2023 at 1:46 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will help print the client's global_id in debug logs.
> Hi Xiubo,
>
> There is a related concern that clients can belong to different
> clusters, in which case their global IDs might clash.  If you chose
> to disregard that as an unlikely scenario, it's probably fine, but
> it would be nice to make that explicit in the commit message.
>
> If account for that, the identifier block could look like:
>
>    [<cluster fsid> <gid>]

The fsid string is a little long:

[5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4236]

Maybe we could just print part of that as:

[5ea1e13c.. 4236]

?


>
> instead of:
>
>    [client.<gid>]
>
> The "client." string prefix seems a bit redundant since the kernel
> client's entity is always CEPH_ENTITY_TYPE_CLIENT.  If you like it
> anyway, I would at least get rid of the dot at the end to align with
> how it's presented elsewhere (e.g. debugfs directory name or
> "ceph.client_id" xattr).

Sure, I will remove it.

Thanks

- Xiubo


>
> Thanks,
>
>                  Ilya
>

