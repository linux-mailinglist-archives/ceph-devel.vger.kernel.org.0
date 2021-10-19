Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D474339E0
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Oct 2021 17:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhJSPNi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Oct 2021 11:13:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229803AbhJSPNh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 11:13:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634656284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=YoRDauoI4hwsOQrVthA9ZUmWPyjnXpm+xIWl7FA6sWs=;
        b=OPmXhYOSoaAq8PPZecmGL9OrZam6Dvg5k4P1VxeNxoXc+UfMtW+iNRv1tF2r5X31EJ1M5W
        TFlMSPad6ah4IkYg/j++BU+N2sVISo22I7RIQ6/F+cLzYPtAXZX76/jctkinB1W15pNOpS
        JG+OLt3nVfnqAsN4nY9PUskftY3p9wU=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-q5ygSQpQOnmVlL7GEejfAQ-1; Tue, 19 Oct 2021 11:11:22 -0400
X-MC-Unique: q5ygSQpQOnmVlL7GEejfAQ-1
Received: by mail-il1-f197.google.com with SMTP id i15-20020a056e021b0f00b002593fb7cd9eso10376999ilv.14
        for <ceph-devel@vger.kernel.org>; Tue, 19 Oct 2021 08:11:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=YoRDauoI4hwsOQrVthA9ZUmWPyjnXpm+xIWl7FA6sWs=;
        b=BrsQe1LZis5mWrBBfsZEat2w9D6u+kVEpkqDl+FKI7S5K20ZruSHPrwRVBfiOSeN4G
         YKpi+/l03kHVhhGL+veNyrJm4ToPW6d7phLGIISHw3bfUIosU1x0fhllBwTK3uz3xEPF
         mZYjF65vvkDM4HJVfMqWNWqX3WP7TyHT0PHBmYPHbP0ej9NtziBaZlvqQsHGIrkQzDpB
         rthwghFDOB0msMHtt3uegx9hubhuJyI6si01GZiBVPlIs41I/8SxkWFYf0LisjPInlCR
         /tRTFtlA2B6kS4qELNz7xCL5/PCJdaWP7Lw+l6Sy6233/GV4kEeZUfLHNhwgd/1M0MwC
         0yZg==
X-Gm-Message-State: AOAM533+rcNiGD/mwkgUrD1SjUL7/IAAULuZDomX5wbGLqd15rAfJ2+f
        oVq5pbtNQOoumx10qvHN/CdTTkAcSWWIUa9063nPeKI/Q6lxFXu+z/aRpa99RzrtL0YYtVKw5yH
        57c5tPgvdPkP1SEBR+w/Y+drftJRemMjVVANzzg==
X-Received: by 2002:a05:6e02:1a86:: with SMTP id k6mr18905826ilv.192.1634656282251;
        Tue, 19 Oct 2021 08:11:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgKubavTWZ9hVT38jkrtewSFQ4diwtrkdGP5iEUZM+fmkMPQgcfKrmFrsrLH/Q1txSFNm+UEBC513kQ4Wwmwo=
X-Received: by 2002:a05:6e02:1a86:: with SMTP id k6mr18905817ilv.192.1634656282118;
 Tue, 19 Oct 2021 08:11:22 -0700 (PDT)
MIME-Version: 1.0
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 19 Oct 2021 11:10:56 -0400
Message-ID: <CA+2bHPYRVg8F8fHA_+puMAcfBtZ0ts=S7ZuD9dYTzP1HNFeO3g@mail.gmail.com>
Subject: Venky Shankar taking over CephFS PTL Role
To:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>
Cc:     clt <clt@ceph.io>, Venky Shankar <vshankar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Greetings,

As some of you already know, I'm the Project Team Lead ("PTL") of the
CephFS team. Team leads within the Ceph Project have numerous
responsibilities including bug triage, PR review/testing, release
planning, and team coordination.

On November 2nd, Venky Shankar will be taking over the PTL role. Venky
is a long-standing Ceph developer who has had a high-impact role
within CephFS for the last few years. Please offer him your
congratulations and well-wishes. Please include him as the
point-of-contact for all CephFS-related inquiries, issues, or
victories.

For those curious as to what's next for me, I will still be here at
RH. My focus will be towards some high-impact projects across Ceph. At
least for the next few months, many of those will be CephFS-related.

Congratulations to Venky! May all his QA tests runs be green!

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

