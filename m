Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC95D3E3091
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Aug 2021 22:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbhHFUxA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Aug 2021 16:53:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235545AbhHFUxA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Aug 2021 16:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628283163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HdaUst02FPsv5xlmIC0uf1PB5BpGZLe3Eu/Nic4jX4s=;
        b=DG/JV2bXVyn9fFVKSH5yQxo/+L3UJ7nLjsxQBxJ4KBj62hEz98bChulMiRpdzPPsqwfyUq
        6XI6wsFkYtcijAzgi7FL3yUA/0qCLIEFw8VwZp2b398TEcNDKQOHl+0pS0JfqxY3TMYyRe
        YtdI8Vziy7AHNqFrYivum+BuWkfoEjI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-6Vdgq1JhNwKqKG8GdvaUag-1; Fri, 06 Aug 2021 16:52:42 -0400
X-MC-Unique: 6Vdgq1JhNwKqKG8GdvaUag-1
Received: by mail-wr1-f69.google.com with SMTP id p2-20020a5d48c20000b0290150e4a5e7e0so3463233wrs.13
        for <ceph-devel@vger.kernel.org>; Fri, 06 Aug 2021 13:52:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HdaUst02FPsv5xlmIC0uf1PB5BpGZLe3Eu/Nic4jX4s=;
        b=YoYiIsZCwomF7F0Xd7ohHTVPAt/1bsaSt3DRrDnXBRb+XUo9a60czLQI8jLQQYa2Ey
         Ss9hRajJPIw+IEM6aUAXAQBGC4lxdcgG7ao/IXAXMWcI/jd/jpSSnHRy2Wu/oChWrfz3
         eYzyjBdGGsDikuWJKwbtmgg1/g6ducA95yK66FBFanPIuxW7l3kEu4dmO1JTVkeZhofK
         9ZIH6zFqKfJ+GKM4sTROSEsa26KxSG9VJpwrIgQyM7/aBvcvwQ07ZORqTRxXfFBOOHHk
         EhEbUCSPaJhLZH5eEyDAiLXZbiXisyzzxi/zD895zX7k8Glf2VH/Yi2ToBmlSfaNPOWn
         uxpA==
X-Gm-Message-State: AOAM530UCtLaNaAemGWHFkA2DvzHs4Ay29YLjPgNSDYfm1+xtAh78T+0
        mumPOwsFiJd+wKeB6WvSmDaFYg3T1NezqvVqSn3HBLmpMzB9Ty6zDo7ugPtcs/uwyFiCFWt3o5l
        Lfpzcn0FRhnubCweRzA6BdKYfkreoTbnURe9VMA==
X-Received: by 2002:a7b:c779:: with SMTP id x25mr21626489wmk.88.1628283160888;
        Fri, 06 Aug 2021 13:52:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSViseFK3+bQGQbU+dH8evhHeoQWmtNR+QkkpJi3M0V6x+7AT3rdrpwu7cQVsoMWTC+o7S3OLC/JDPObFDkBM=
X-Received: by 2002:a7b:c779:: with SMTP id x25mr21626478wmk.88.1628283160751;
 Fri, 06 Aug 2021 13:52:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAPy+zYUwvOap_yFY93PF+xvri-f1MwDRO2bZM=yyx21yedvegg@mail.gmail.com>
In-Reply-To: <CAPy+zYUwvOap_yFY93PF+xvri-f1MwDRO2bZM=yyx21yedvegg@mail.gmail.com>
From:   Casey Bodley <cbodley@redhat.com>
Date:   Fri, 6 Aug 2021 16:52:28 -0400
Message-ID: <CAF-p1-LQRr=D_Ds0_tX+WHJWxM23+pZXBBgf90GorX6b5NaZVQ@mail.gmail.com>
Subject: Re: s3test: In ceph-nautilus branch , some fails_strict_rfc2616 test
 failed, Is this normal?
To:     WeiGuo Ren <rwg1335252904@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>, ceph-users@ceph.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Aug 6, 2021 at 6:20 AM WeiGuo Ren <rwg1335252904@gmail.com> wrote:
>
> I want to test  test_object_create_bad_md5_unreadable. but rgw send
> 400(e.status),rather than 403.I dont understand it. The code is.
> @tag('auth_common')
> @attr(resource='object')
> @attr(method='put')
> @attr(operation='create w/non-graphics in MD5')
> @attr(assertion='fails 403')
> @attr('fails_strict_rfc2616')
> @nose.with_setup(teardown=_clear_custom_headers)
> def test_object_create_bad_md5_unreadable():
>     key = _setup_bad_object({'Content-MD5': '\x07'})
>
>     e = assert_raises(boto.exception.S3ResponseError,
> key.set_contents_from_string, 'bar')
>     eq(e.status, 403)
>     eq(e.reason, 'Forbidden')
>     assert e.error_code in ('AccessDenied', 'SignatureDoesNotMatch')
>

yes, that's expected. that test generates an invalid http request. as
of the nautilus release, both the civetweb and beast frontends of
radosgw reject that header during parsing, so return a 400 Bad Request
error instead of failing later in auth

that test_object_create_bad_md5_unreadable test case no longer exists
as of the ceph-octopus branch, where we switched to boto3 which
doesn't even let you send such a request. the remaining
'fails_strict_rfc2616' tests accept both 400 and 403 responses

