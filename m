Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF374D442
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 18:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731733AbfFTQwJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Thu, 20 Jun 2019 12:52:09 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42051 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfFTQwJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 12:52:09 -0400
Received: by mail-qk1-f194.google.com with SMTP id b18so2366486qkc.9
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 09:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iNXuAu4HyvtZkrU/GiQrzdVFqka+BgFiUWqI6l2mjwg=;
        b=pm08xviRED1Ygq40QA4zQRaRWELI1+j/anJWV76WO0g5YvmvKWenvZ50YNsQ3YV77v
         +m1jowc3UJKKA5gsX7EjxWrHnnDL5KNMXNTb7Iss3YpdNCkDAzE0rkQRmuCuQHBYt6MG
         CCwZ0+GYULq0pD1Tyi2WXV7it5SHou3BWVzMynSU6c8XjtQYUmUSBcDWw8uDmW98+HxE
         4iy3gODUwgHn1zpF/C7ycznWJoHonOjFNZKWewFSECirxRrDH1viQhH2wkqKIiQbkgNv
         +iq7+QriGgqQnxAV61VMuVBPOBtmaWVNRbOvbjP8uNUWqGj1E1bOh0Dn0tqZl28yWIyX
         CliQ==
X-Gm-Message-State: APjAAAWg02vlvSe0ltOJSkMhD8daWyXEEtZno6Sog+yaVBtoooSoagS9
        2vJONK0zejo47A27TKCfqHE8DGARnXTz+BLE0mEapg==
X-Google-Smtp-Source: APXvYqzcyJwbka/ul4Jh7DvOASqHWEpbQ+2YtgUv87VKVO3OQGsifMcKU8+cxnASDILI9EKGe6qAnSyk/z024VQSCEk=
X-Received: by 2002:a37:87c5:: with SMTP id j188mr84976736qkd.106.1561049528526;
 Thu, 20 Jun 2019 09:52:08 -0700 (PDT)
MIME-Version: 1.0
References: <221D4B4C-BF10-4E9C-AB29-BDD1F1563941@gmail.com>
In-Reply-To: <221D4B4C-BF10-4E9C-AB29-BDD1F1563941@gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Thu, 20 Jun 2019 09:51:09 -0700
Message-ID: <CAJ4mKGaguzpoo7in5gA9igg3DiZRGc7wruNwroOS_2ttd3exPQ@mail.gmail.com>
Subject: Re: backport PR https://github.com/ceph/ceph/pull/26564
To:     =?UTF-8?B?6Zm25Yas5Yas?= <tdd21151186@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 19, 2019 at 9:09 PM 陶冬冬 <tdd21151186@gmail.com> wrote:
>
> Hi Cephers,
>
> Since this PR is important for lifecycle to be able to work.
> I’m wondering if there is anyone working on backporting PR https://github.com/ceph/ceph/pull/26564 to Luminous and Mimic.
> I saw it’s pending from ticket https://tracker.ceph.com/issues/38882 and https://tracker.ceph.com/issues/38884
> I can be able to help to work on this if no one is working on it ?

As it's tagged for backport the backports team will pick it up
eventually, but if you want to do them yourself that will speed things
up!
-Greg
