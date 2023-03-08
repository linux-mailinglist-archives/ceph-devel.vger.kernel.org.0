Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9859F6B0C5E
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Mar 2023 16:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjCHPRb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Mar 2023 10:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjCHPR2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Mar 2023 10:17:28 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568DE637E1
        for <ceph-devel@vger.kernel.org>; Wed,  8 Mar 2023 07:17:25 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id b13so16957455ljf.6
        for <ceph-devel@vger.kernel.org>; Wed, 08 Mar 2023 07:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1678288643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UKWDpQGgZF8cCG8UI22TObr4EUZ19uJwWb4ZQAfyAGI=;
        b=TmlWVpTm+qZV6kc4aFOaDhGlNVreDHX4yADRfTSq/0J308e6WJ6nYEYjOx5G8lvhjB
         tDY75Dx8Gm2njCpvQeLJX00qJmy2Ti13sVrdVLLwYGhaI6M3NansuOeCje4D1HATNrnZ
         DZgqiGS81loFvD3jJBN46N2SMSiH5Yqpq7iLbCsZFXopufmD9zO6v/6/1CC5Qc+nrmL5
         vOZYiaOtzvCuV0ZZg87M9uDla9rce8nR/GzoIQBE0pVL+g5xrrD0cQOFbwfMUyIF4TTb
         MyYtRPpLiEUPo88Y9t/1dMfHxVkuCBTN6UfdIWbEvSmoNEqUeDO4Em0pxeqLpOrHaX3K
         9BqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678288643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UKWDpQGgZF8cCG8UI22TObr4EUZ19uJwWb4ZQAfyAGI=;
        b=v1Nh64CGjEUErygqLZvrVw5422dYsQERq0RjFMGcezVfyYUKfZhu8DSF5TU2v2QOFl
         K8veUB2uhlKo7pIM1ezvaEESU/djJN9NtUTeAo1eTo481CylLUl4zPmBIknJIUMw9LFV
         UPwI4gbUJmemlepPGyz9mPFYmseepXEOSJdqH5hWPTgXegy+cLpqPrD9VW/m28mDuY5T
         xmoBBgPmqTaZxP5vHgvKHmiBgPLUjN8jJmqBRcPz7kqADk3SVAv6Q7NX117GbaBrElGf
         cTwo1h0C31KSDYr1HxZAl1LKlGZ0ePL6zJY02gH4w7AJUDPo4CvkwFrkxdOCvwPqHhRJ
         Ho7w==
X-Gm-Message-State: AO0yUKWGVDTXWtKlq/4/CMzRXhTn5JoPXnzcV0Z8PqjT8m7zEfZkHm1S
        QVlk+sCoD0+P3nEHWxWUexOwoUFCNGt+IxnWIAHl0w==
X-Google-Smtp-Source: AK7set+vniQJG/0lI0rUk1n0REpuhY8BrDdBQDJ4Y2Wq5dU7ODMW0E0q7WWsBHNnwAxNb6wzWguSzJzRRd5UG4SIqT8=
X-Received: by 2002:a2e:58c:0:b0:295:8ef2:8711 with SMTP id
 134-20020a2e058c000000b002958ef28711mr5652416ljf.10.1678288643584; Wed, 08
 Mar 2023 07:17:23 -0800 (PST)
MIME-Version: 1.0
References: <20230302130650.2209938-1-max.kellermann@ionos.com> <c2f9e0d3-0242-1304-26ea-04f25c3cdee4@redhat.com>
In-Reply-To: <c2f9e0d3-0242-1304-26ea-04f25c3cdee4@redhat.com>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Wed, 8 Mar 2023 16:17:12 +0100
Message-ID: <CAKPOu+_1ee8QDkuB4TxQBaUwnHi4bRKuszWzCb-BCY44cp1aJQ@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: ignore responses for waiting requests
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, jlayton@kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Mar 8, 2023 at 4:42=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
> How could this happen ?
>
> Since the req hasn't been submitted yet, how could it receive a reply
> normally ?

I have no idea. We have frequent problems with MDS closing the
connection (once or twice a week), and sometimes, this leads to the
WARNING problem which leaves the server hanging. This seems to be some
timing problem, but that MDS connection problem is a different
problem.
My patch just attempts to address the WARNING; not knowing much about
Ceph internals, my idea was that even if the server sends bad reply
packets, the client shouldn't panic.

> It should be a corrupted reply and it lead us to get a incorrect req,
> which hasn't been submitted yet.
>
> BTW, do you have the dump of the corrupted msg by 'ceph_msg_dump(msg)' ?

Unfortunately not - we have already scrubbed the server that had this
problem and rebooted it with a fresh image including my patch. It
seems I don't have a full copy of the kernel log anymore.

Coincidentally, the patch has prevented another kernel hang just a few
minutes ago:

 Mar 08 15:48:53 sweb1 kernel: ceph: mds0 caps stale
 Mar 08 15:49:13 sweb1 kernel: ceph: mds0 caps stale
 Mar 08 15:49:35 sweb1 kernel: ceph: mds0 caps went stale, renewing
 Mar 08 15:49:35 sweb1 kernel: ceph: mds0 caps stale
 Mar 08 15:49:35 sweb1 kernel: libceph: mds0 (1)10.41.2.11:6801 socket
error on write
 Mar 08 15:49:35 sweb1 kernel: libceph: mds0 (1)10.41.2.11:6801 session res=
et
 Mar 08 15:49:35 sweb1 kernel: ceph: mds0 closed our session
 Mar 08 15:49:35 sweb1 kernel: ceph: mds0 reconnect start
 Mar 08 15:49:36 sweb1 kernel: ceph: mds0 reconnect success
 Mar 08 15:49:36 sweb1 kernel: ceph:  dropping dirty+flushing Fx state
for 0000000064778286 2199046848012
 Mar 08 15:49:40 sweb1 kernel: ceph: mdsc_handle_reply on waiting
request tid 1106187
 Mar 08 15:49:53 sweb1 kernel: ceph: mds0 caps renewed

Since my patch is already in place, the kernel hasn't checked the
unexpected packet and thus hasn't dumped it....

If you need more information and have a patch with more logging, I
could easily boot those servers with your patch and post that data
next time it happens.

Max
