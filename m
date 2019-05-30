Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49F6303ED
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2019 23:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfE3VPW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 May 2019 17:15:22 -0400
Received: from mail-it1-f170.google.com ([209.85.166.170]:52746 "EHLO
        mail-it1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfE3VPV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 May 2019 17:15:21 -0400
Received: by mail-it1-f170.google.com with SMTP id t184so12347267itf.2
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 14:15:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oQmbLXLzD02l8lXxOcJBpr+oDn+EKYUYZgnIrk+MaoM=;
        b=pS5SKaPh/Y/OZhK3vGDRC2gDa7ky1FWOGXnIWWwscqT241jlF8ntn4iVHiRrp8+opo
         Oq2orlsZE/rBHcxepT8fFdwIWiSBQxMX8FVYbzOqawCd1ZOG696+hOyWi0v87wv7VWVs
         NhdkLHV6mbP09fg+XK6zdkSRk4NrIHJWXaW7zcvqGkfNfKbYBCpcdtPrCginAs8+AJ0M
         rl5nC9sVuwy5mDwL+DDBRJycNJKSkzpJxmfVS9F8E2yupv4yYTShup0jmu7GmNHWR/Tf
         nWgf+xa+VFtXozT+ZU8wMjwRafDmc9NzkOP0PWqQRuuMfcSy1Oa61v7NjrZ4qq4R7agT
         Rs8A==
X-Gm-Message-State: APjAAAWFlv26L4pXSztzcTsOCaiH8EP/R9HhQhvhuAUDuJPF3sPUZ6Zo
        9iTvmC/0fJmXnazerjdb1l6KawpZF+2P+9h+u0/fQ/Zm
X-Google-Smtp-Source: APXvYqx8y6+OwgnSP90pbfDflWAKsPrFBi0bAsw4El2Zpg7hBpzhnqaNxdW1z1PpkJTxMzLF4s8m1f1cQGSdkU8kBqs=
X-Received: by 2002:a24:7345:: with SMTP id y66mr4375926itb.23.1559250920352;
 Thu, 30 May 2019 14:15:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAED=hWDpWZf1Oo-9QEKhW7Hdeg7LHsN3vANKxcCHY50nnO4VQQ@mail.gmail.com>
In-Reply-To: <CAED=hWDpWZf1Oo-9QEKhW7Hdeg7LHsN3vANKxcCHY50nnO4VQQ@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Thu, 30 May 2019 14:14:40 -0700
Message-ID: <CAJ4mKGayist1DGKZHnsNdN-i0MDOhtwDuOOn8OQdpXmO-jzROQ@mail.gmail.com>
Subject: Re: does Filer support caching ?
To:     Milind Changire <mchangir@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 30, 2019 at 6:47 AM Milind Changire <mchangir@redhat.com> wrote:
>
> Does class Filer support caching ?
> Or
> Where in the client stack is caching implemented for libcephfs ?

Check out the ObjectCacher and how it wraps the Filer from Client.cc.
-Greg

>
> --
> Milind
