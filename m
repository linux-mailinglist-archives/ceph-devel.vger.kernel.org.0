Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6211729B00
	for <lists+ceph-devel@lfdr.de>; Fri, 24 May 2019 17:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389541AbfEXP1o (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 May 2019 11:27:44 -0400
Received: from mail-vs1-f52.google.com ([209.85.217.52]:40838 "EHLO
        mail-vs1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389203AbfEXP1n (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 May 2019 11:27:43 -0400
Received: by mail-vs1-f52.google.com with SMTP id c24so6046430vsp.7
        for <ceph-devel@vger.kernel.org>; Fri, 24 May 2019 08:27:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=9tjVIF3OCsHuYeoEmktgoRXqp8Do026gOpfq6aUbHTM=;
        b=Jy9Iz5EfcYROhaKzdVcxvn/kiHwIJmY4FlWPzpHzVv+szuVUhDtN95FYDejPEF16ty
         jR7lrB9mg3DbMC4R36s4tUZSyocKfF1dkYG0+LJEciPix6QcnDFAKd81XmSRAWoK2qxk
         HDlWsQPDXN+EfOJ2HX3j/9cMJ0LkIyrezhqKGYx8WZvghVwbbW1vHInQtzo7lIK88/hj
         GhgfNQgOVTfikn8aw5Ek71DzxsidMQqhmailL1/fZspLP9JwK4mumSIXIAEOjoIiW6su
         yvp2MVnXQHU5nJps1uvWKLgoI4dJ3THgaVu0hpeTWmQcSdietw26uHOUqSVmNgwoa2O3
         dMcg==
X-Gm-Message-State: APjAAAW2FLmPF/mOliz8ObUnF2a4QnRNC+UW9WT3iJZGF6JcQy5gw0dd
        AiZMNnxxUSloBXKISloGINnBcO4Ug0/kYw==
X-Google-Smtp-Source: APXvYqwE7KmoUQUYICaAI9g+BPGa44rSPrMBFlDg+Dnrnu31VXmRziCfmhPLbaVLIFOM/H5VoEeCBg==
X-Received: by 2002:a67:2686:: with SMTP id m128mr13669000vsm.130.1558711662597;
        Fri, 24 May 2019 08:27:42 -0700 (PDT)
Received: from [10.17.151.126] ([12.118.3.106])
        by smtp.gmail.com with ESMTPSA id h11sm389933uao.10.2019.05.24.08.27.41
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 08:27:42 -0700 (PDT)
To:     The Sacred Order of the Squid Cybernetic 
        <ceph-devel@vger.kernel.org>
From:   Casey Bodley <cbodley@redhat.com>
Subject: Code Walkthrough: RGW Multisite Replication
Message-ID: <8ae71fd6-73ff-3fbc-b2a8-5a7c5a99d178@redhat.com>
Date:   Fri, 24 May 2019 11:27:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I did a code walkthrough of multisite replication this morning. Please 
find the recording at https://bluejeans.com/s/zR8z6/. I'm happy to 
answer additional questions here.

Casey

