Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3984566A5F6
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Jan 2023 23:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjAMWdD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Jan 2023 17:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjAMWcp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 13 Jan 2023 17:32:45 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D5B8D5E1
        for <ceph-devel@vger.kernel.org>; Fri, 13 Jan 2023 14:32:16 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id v23so19930892plo.1
        for <ceph-devel@vger.kernel.org>; Fri, 13 Jan 2023 14:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=TX2ITUSoiij4MR7y56NOK2ED/hkFtNiMURj9FlxXzbIhibPYIdzOg9v7ujoz5xhjwB
         Qi8qYo+nN5nVrF5ng7scli1BgPoX/Y91yKLmHl+2VeCrS5C8vI9QMyul3UItcnzhi3IK
         Oea9QvDzS9k+zGz+MMFcKR8Cko2+wmWmfP8/Et2YlGrmK990hqCD/hItE25qDHGp+o2X
         OVO+FjD/x7vPIbKgyttKVtntrQuukRVeB+7V0v3YRdYuWM56QtFYefCeZ3nZF2nQFOT/
         VgA+ZvnpfNzWU341HV5p56BfIkvpcS9Zcla7QJfDnwQJ7+JN2f1RG67vz4aSOdovnS/n
         Raog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=wFYvjCAngRF4rlKlvHIFm5YXf3kpJPx4VpiagaddsPLD4KFs1FCLm3pSNZNYm0XFW/
         0sHWLr24iOpaJc8oCba8BTsc+v91+cPnJSzVtZQVBVH0bJWLr1jyIJsqeZqKBhkPIX6u
         GzPPsBQEbJ6lu0kw6Ua72Bq5ae9r8YRpPOm30+I0ACOTwj6YC8uPrmz2+wf+RDSNW8hL
         3xQYlqq8UROvnUrHCvjzsYbs965839nlC14GTkzCTaUqISPZySxTJE2hAmDWNQMHbgOA
         jzD3sqEftB1ktN8WNk1rJnqWYP8ixrChCUqmlYKdsawXYVlooxuAOVOzjHiC+qmT+fVJ
         7vOg==
X-Gm-Message-State: AFqh2krwGEZvrGTA+w0tHSF8b5ggYF2Tm0hPfESz6pSF7H9v4xdJxRph
        d4dGXksKTTkuEfdK33s7QvQ30Sq1bqsAV5ka/BIGRxYrRRg=
X-Google-Smtp-Source: AMrXdXtTDJHxPzuFQB2/Y6nFIfReNddmXa/hiOVapmJY+qv4U5uQUOGZLJRfH0E/AsBn53aZos5ukqZgHI7NUolKHtI=
X-Received: by 2002:a05:6a00:1244:b0:56b:8181:fe3e with SMTP id
 u4-20020a056a00124400b0056b8181fe3emr5621436pfi.57.1673649124799; Fri, 13 Jan
 2023 14:32:04 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7300:610a:b0:8b:17f3:698a with HTTP; Fri, 13 Jan 2023
 14:32:03 -0800 (PST)
Reply-To: ava014708@gmail.com
From:   Dr Ava Smith <avatue70707at@gmail.com>
Date:   Fri, 13 Jan 2023 14:32:03 -0800
Message-ID: <CAOo2rrmbjraGJgAxJ5kMb-mNoYVE5ogyjOYtGgVZvKfJ6ziFUQ@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
