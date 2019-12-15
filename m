Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1EC11FB9C
	for <lists+ceph-devel@lfdr.de>; Sun, 15 Dec 2019 23:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfLOWAY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 15 Dec 2019 17:00:24 -0500
Received: from mout.web.de ([212.227.17.12]:58279 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbfLOWAX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 15 Dec 2019 17:00:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576447210;
        bh=MEuVMTzxFT03+YnVTN8Qa/paKtmADt3WIQppotGSB+0=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=SyC4FGUs6boEW1pQD/qh5RTa8pjAQBk1Mw52knF027CQkCpdW+57/ioBJsZ0FKFVy
         9sPbTNUrdwZ2aIshaQnqxjMZZjBoForFrGPp9KyIJWJGS2mQu9Hk4LDuh2cActlS88
         mc3KsA21y0BqWvBARKDu3VCy8Ri9GAm2lYHTgIJ8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([2.243.76.50]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M3jwL-1hq1LX0FAP-00rL2W; Sun, 15
 Dec 2019 23:00:10 +0100
Cc:     linux-kernel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Kangjie Lu <kjlu@umn.edu>,
        Sage Weil <sage@redhat.com>
References: <20191215163527.25203-1-pakki001@umn.edu>
Subject: Re: [PATCH] rbd: Avoid calling BUG() when object_map is not empty
To:     Aditya Pakki <pakki001@umn.edu>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <2b5305f3-1224-01a4-ee52-5e05b92e56d6@web.de>
Date:   Sun, 15 Dec 2019 23:00:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191215163527.25203-1-pakki001@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fVDxTeu5YavYWreg6nYpuyDmw0DU/PFA/q7RcKJigR0hVGq8Jij
 wKtlNM6Gl58PTQkrauhXor0mlek6f7a70eh45qsoiLM6Sf2Csoz7HHXo1UY021MF7SEP1Ia
 FM9KNysKPx5EnGQSQkW6O0OlXLSVhZFBqDK4putHRV1iVIji4m2smiqXkALnOJrj/DSwCxC
 wiCH2BcOQ+LQUNX9HOh5A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QZDpB2b+TCI=:fNzrWN/6qzH7xsjxkHZfRM
 ylRGhop23RXq4Q6TbmhtFMpi930GEagxJ37VL+QbfwYHRbNJKHxUGfqb0nj6RY+02LLCBrWf4
 HWq8fT8h5ESgKbk5gv164kPj/LKgKecew8lQVT6hHFuS1gvyKrlyA597MSlDr7GYF8WWlTHfm
 aFg4/d0hp8eYK9mU29qdSeXZ7IZEUYVaz3nN0lHjbak9zJqmvV/jyVTQRoQgDwjAQxVFYTe+d
 NEUGGg9vLvLnNaC4amJSGbbDIH7hb7b0aXNzka+Gklsuy0GI9POKui1IY3o+r/+6X1+A54qR1
 syB96TmR/vvo9VDMuC6BUEjx/t2UzTMoU+HwpoQtfM/xwaVvDJjZPXUGm3srZ5d7KmYmdIPGs
 bV2kq/eND5ZdbYsUyk4QjxEwAljtYMSmGinloE7dR7SkLUQ2sKJwDX4xcNB9wTKzlQc6FyW/t
 OSXaxBV8Pr9oLxG/+K/1ixCz9J1sqq8D9riDmuXXlOdZbeF1427nnAT65YqIleyWeQhqZ39Un
 wsE1Y6P92wGLEDjj0ay1urByEfVr9husEStf9qtgl+/N8gff59u14TYKO1cLezHSIbgneoJmx
 c5ZO3HdGSkXhuKJjyLA3WzfT6bDOoglvv0V/yLWtbD5VfPubtOfSNt42SIYh8+eTc/WkKDUIw
 UOhgIBzaKEkCkYDuP4L2/E4wUqX1norDtlRbOhavIn5zpzAFfGNWQIgJ50toRIcy7raX6Vkd/
 eJw5M6cNTIJKmymxA8DuXeprqwxJCAGonj6El+VZx5YUfnNt0moCYYbTxLgIsKQ2XgZZGD/i9
 7tNalg9NPjm0S7ZVzUg2fdl/5Ft3hE22dygbh1QlXcQyNQVLZbBjeI8rOzApzvDNu9vJ+WojS
 RDT4rkVavBORvcuk4F7DUmIsvAZUrq0mGEHbNtqyZcujJ6nY+VYpaR+bsa+ISMhLXEMBgpCdI
 fLXU0JjKeiBpjWSs3rDUaPVbQKgxPQeUnu1Z9GSE/Rfp0QUkOXdtq9RP0hr3GfqAIkqWIUDGq
 WYXQKm854ZJvzJQo9TD73LIHu5Cy0gw7DG30fosiC5RvhrYVpplWatGzCMNT1HbHMWAPR3R8w
 sIzxdtNxFNQrk5xl5PSuRAnBA8cfLNI+a05fXoXMweYQ8fJoOGH+h2q2Ic2/RDRlUcoeJFAlF
 Wf5nrAxYN9ETWgB8rYJsjLM334SLLpySQslun/U4oRDaFjgzl/sFA19y1cyvXAGwJ9EuUcCq6
 KYRrwvyLGpNLWNg7FQQNfQpP82dZ2kpw7c2pBw05IJkV3VfAOh7RC65Pkw1M=
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

> The patch fixes this issue.

Will the tag =E2=80=9CFixes=E2=80=9D be more helpful than this sentence?

Regards,
Markus
