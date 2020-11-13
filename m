Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBBF2B24C8
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Nov 2020 20:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgKMTm7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Nov 2020 14:42:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbgKMTm6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 14:42:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605296577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5N08Tkf/bb2j23bu9XUiBtqxIvVwqO42F+0kMAOlpuo=;
        b=itIXdFq1nrqlV6jQGdxY1Z6/n1zBQHtTUM3OmIDQNNOSHK+lFKvKKnqkNMolmKQtNNw245
        U5e30yT77iFNG+J/OBrwGW+wSx6dhxd0n+zT9BVDbzMkMOKW6woT7LpQZm09ePHAywMN7F
        uf2FFrxh1eUBouKOOESU+dai2seIYss=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-6t8wcXzCOXCZahiymP6Upw-1; Fri, 13 Nov 2020 14:42:55 -0500
X-MC-Unique: 6t8wcXzCOXCZahiymP6Upw-1
Received: by mail-il1-f200.google.com with SMTP id u129so7284129ilc.21
        for <ceph-devel@vger.kernel.org>; Fri, 13 Nov 2020 11:42:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5N08Tkf/bb2j23bu9XUiBtqxIvVwqO42F+0kMAOlpuo=;
        b=MXt1mQ/veWj9MDB+dSCFfnGDTnrmzr/SWV7QnYot6EfQJCAlDwjyUYw8nUbawHviIZ
         nVAKpF6/4YSlOCfz7/gZSlza1JTZkbedq3fAYYbjZljTBNbhjaVKGK1+sOKui7w2EtUn
         SH3QfBz2oztbQ7eYBC8vQJtzhP5JZac9Luf8w6MpmUPmk5dZSssneTGdJelK1LWkskRk
         gquiyOcsR5uEyVp/VyX5ENIstrHXeJFQyxuV1t4yfafyzydmCRcGMph7qxpxXhB9ODDm
         eTeVMppqZUoXLuIUMoJjFZQ6C+T6HVcMGrwcoQwDYczX3pGz1UwFpyFbdji8eu23yIwy
         R9jQ==
X-Gm-Message-State: AOAM533D1eFNbr5fexvVGmPr2J4vyRKM/Gogj92LPfblrPXGdyfBuI7X
        XSJ9aA06J9yHRJZUUvOZh2n4GN+wsPoF3HOu0BkdhsRxUTMRHgGRZBJTFUxdFr9bOMv0zJXFrcm
        geBM/IIkk5iFzn3E0RBQ/1FOy7rlFPRohTAYG0g==
X-Received: by 2002:a92:dd91:: with SMTP id g17mr1097995iln.180.1605296574260;
        Fri, 13 Nov 2020 11:42:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYAYryF4/akgtqBerkSQUjoVG5BxqHi0cO0NSi9PO//fiECStxGDo2QWMpM60tKhRXjrsRmm4QCSVqo/UfhaA=
X-Received: by 2002:a92:dd91:: with SMTP id g17mr1097980iln.180.1605296573958;
 Fri, 13 Nov 2020 11:42:53 -0800 (PST)
MIME-Version: 1.0
References: <20201110141703.414211-1-xiubli@redhat.com> <20201110141703.414211-2-xiubli@redhat.com>
In-Reply-To: <20201110141703.414211-2-xiubli@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 13 Nov 2020 11:42:27 -0800
Message-ID: <CA+2bHPZfW8+zEuhxjxJ8dJzj70u2LGvKcxhOnGOXM9sjK_oSTQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ceph: add status debug file support
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 10, 2020 at 6:17 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> This will help list some useful client side info, like the client
> entity address/name and bloclisted status, etc.
>
> URL: https://tracker.ceph.com/issues/48057

Thanks for working on this Xiubo. Do we have an Ceph PR for updating
the QA bits to use this?

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

