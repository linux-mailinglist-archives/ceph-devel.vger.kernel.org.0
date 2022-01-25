Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F5E49BCB3
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jan 2022 21:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiAYUIj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jan 2022 15:08:39 -0500
Received: from sonic304-31.consmr.mail.gq1.yahoo.com ([98.137.68.212]:38186
        "EHLO sonic304-31.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231377AbiAYUIN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 15:08:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1643141292; bh=rWxb8cQ8pqFpaq9VbD9Qq82RKVFFqO5ypgXFBffF9YM=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=krN7hwYx7+AYJKMWQhU3Cf3gHkUPaG12zmA/a+LFCAV6oaMD80atbes4ven9hyA+5B6e0rYCTwWiuaQQslTgesSpHQC0tFyFRIfWDH0u3oCOXR3NrhBwuhYDZ/utUa+ejdVv0/jgrLvZKpqK+VBV+PVNoK/vqcYEEUrzLueSnmefQWJN8mGBnbOXBb7OTaarJTeSrgYNOTQB/kd+htjNa9iLiLiukSYIYN31rLPQZs0r/mUpzF2qmPk0XkLW3gYGLX/PQQkl3bseSRv+Qa9aPESj3IPdZO5g5sP7E7RpKY9PoMuvUb2L5BlBJh5d4xBJGD+yGQnmClk+BqFTgrNpfw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1643141292; bh=m9xz/XQP0UvDcKsECFN+60kapLUnx2iswd93GS5GP6J=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=SpfFVj7ec0dlOMzYQhfgs1lMhQ54d37pH84bxRPJgfMs2Zn2h9plxZnW8DD8+SnW0T/0oTffi7G2/q8/X9ufp6/JDouwINoBk3auVeikl9wnWwvy7iv4DDtvZsX1cfvQzo5WSploAQNuxtG+IZG8CpPumHH86+KesQN5svberXn0rpSPKkVUpqkLh0JTIbEJ+lEjp9S71UB+oOB54WqfCZjvHCVO2KdBwg2tjMKLFSu2ySI4tfCCRbIENX/rYP1bnZ3okOkeqH5++0HZsqyW1Zkoka1pwuZNn/41JaCbkgHeEzRBLgVhbCNLuDnFBPvd5aD0/07xNEPXH21bDrzjjQ==
X-YMail-OSG: 7TFw_NIVM1kE5yyKTK.LOho8ddYjhOX6Tyr9HW2e7RAhgoSKmFPY0cKdQH0MYnX
 af4qMGYCgGoZaR4BDnVHBnbAPa7A9k6GShYgT6wG5ijHRIS.F7omakewI1PJXSjSpWaiS8bue2mD
 zeYeI25HYMEZAl3NezUa6ZtRwMFW3eKb6tfu5qrIjylw.ZIFv3aMdivoozAaBwLD9L13YmeDx6vN
 nILCGbTbQTqq6w4HkrDg5yMIM4WsTFWR0UG3LslKLIV2ovvlx4sQFJsDRZtfocIHN6XR1ctdgHPI
 yXxqXRmH.X8lXFMWhSDNlzRpxqvEptZDly9HxQvw2packvB1W06LC9_dPOvhFAuHONhe7j4D0WMP
 JypqJOEbuSqUAJUtDdHlrNwjcVpRlyjOKOb0eUIGaQOQyhHyJXfb6m8XwCwCZwmKwhePHR1vdFst
 xv_U7B6VCulAUFBsMAt0oH4Q3hCyVI560ZHprS9vE0RhjlCMTzu0vuJZHusv3_uLp7736vHZCWic
 7BaMxp.ZdobyMgDcgcSMAHPj6b3WD5PhDwSpGLahQM8jc0VtUxjzURdwms93TEu28_gHYAg4Fj46
 0U825agEVT8KFjsrhoPr_tNlZq451cSxBvMwZ2JmALyJfye.Zky4DtJUxhWMoXyaE3iNNdQ4dp6r
 v1E_Sbf829AWmvpHC_H2Y8lyKzYi8q.qV9LIZ6ahV_JeZZ6.i.L8TmBwSZZxdopC5kme.oxp91Es
 6_akucfNNqA1kGegDiPnQB2wr4EJOYg8nw3Gkp_cr3EZXdeZLcA9pac11HdmnSTT7cDr5YIH2JMg
 l3buUYnFR.pAGPzoT5HTPcKAcpNyYvHwxf6.AVlSpV1H6Kcveakb2xNekHLc0KGUqiupNyav03td
 M6LUydaKJ3vuF3Nw9oIZdtSG8.hsKKyF3OKgjpO58u3IcZpR96c7vVm5ZodAbY4CCW8JWNNmrPxH
 lQCEpZS6c6YEA8jjxO.H8PiCp1WtrrZVJ09eqvEBwmb2_pGF2CbvfL1Bt1aLsnxb_3v9TLHTRqQS
 QBGpiPfhAdckuPy7He2yxQ87cE6ZTZpJ1zxXYljnHHE1ISlJ7lMGXyDJYhbMvQ9PGX9jf1ZtDuTy
 .H67gmzm4up5jCIuyHw3dHKzonOLXbPXn4PTd8rP.Rarin.jkwmprDK9s2Onc_ci7A9wAgzNghI9
 .HHo1DMPGg5WShi.FwA8toG8cx22S0Ex8gCC36jD8J1D_0uFdRihHkYxlB_Tg8gKKxeebtQox7XQ
 W._4guCTAsjfrvkx_jgjl34OBxajn_vTDJLHyyyGkbEWTkGE9oOIiQ6nukcf0vmA4gC2CzQH6N3Q
 7Uzq9hui9DPRH06KDedqKL8MsoBY7YBFSpP.JJEMvrU5WPKFfCI0hkPSNscjO1.hicgvNNUPYXHD
 Ero42HP_1_UNcOR5zrttT2lKnKe2tGfiEhI4FudlVpuZExs9J6H5j77qhg6ipsw0qXN9jscPRSug
 ziodzPvv4dg.LApEQjrOZkqAgWGogl0M6flQR3EawV_1GXsaJdktaUwvpJrUoBi2AtDR45LXgcqv
 Oz9HWTAHOkG8.CZzQP6FpUhZdNkyfEJPISkZtW4DZvEQTS8AIjAkYJIjpxGtg7iM0b6JYDFEgEah
 L0TAz9sv4PuaLlCgtK_LulGx9VAUBDy6ifYWjRunr_iODfXtqcm7T6tDjP2fQpmVUHRSpbxG2iR6
 wtA4ecvPu4vPPInkAb8srpHDBY2rrOwMRs3XnI1loDi7p3gacydI3lNVwbqxNwanWiKZPGili4a6
 mViEIEDSMdS6fvFy2XILDUETnHlSV66F07SB.Uv8nCTdJDlkJ4rD9AMZ6yYeMhguG2Ze41e_eRRT
 Nvm66zBLc4Hqiyhy9ShOzMW.ideTFE0dt6FJAiy95O.pbeY8nVkx93R3VEIidKBRMlRsciG0j6IX
 a6Wp4Rwv5Tl5Oo5rmU4PWDNufg.QpiXUzP11wTvXoKwV7gL5h8ssRb6IeM5PZIT3zd0Psu2IV.uO
 _wRkdSlE4bhcTdDYwKyCoecnuJTO.7caNWNPWlhXq2k2WKQjSCtZ5r9kGj_GyB.XBhmU8b.dEjBw
 BqqrKsm4JK9H5zGO8ApK1CAzMnBiMGK2BkkU8X.U1WVCRgznnQmR.0e_TAkZiy5rq0V8m379M5Pg
 U9sgEOmRaBnhcCEnMwCWkQ5fkMjnXMMSqx3qONe2qw2oFebxzb5IvSTTGr8_Nxd8zbzeDucc8qjE
 K4x4jxOyk
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.gq1.yahoo.com with HTTP; Tue, 25 Jan 2022 20:08:12 +0000
Received: by kubenode533.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 683e975d61f09c1a89b873a1c7ec8abd;
          Tue, 25 Jan 2022 20:08:06 +0000 (UTC)
Message-ID: <d7e9ea17-3fa6-62cc-7ffb-f63c06b40a90@schaufler-ca.com>
Date:   Tue, 25 Jan 2022 12:08:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: "kernel NULL pointer dereference" crash when attempting a write
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, vgoyal@redhat.com
Cc:     Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Stephen Muth <smuth4@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <CAM2jsSiHK_++SggmRyRbCxZ58hywxeZsJJMJHpQfbAz-5AfJ0g@mail.gmail.com>
 <CAHC9VhR1efuTR_zLLhmOyS4EHT1oHgA1d_StooKXmFf9WGODyA@mail.gmail.com>
 <a77ca75bfb69f527272291b4e6556fc46c37f9df.camel@kernel.org>
 <20220125111350.t2jgmqdvshgr7doi@wittgenstein>
 <d5490a7c87b8c435b3c7bdb8d2c8edef2c2a576a.camel@kernel.org>
 <20220125121213.ontt4fide32phuzl@wittgenstein>
 <ab92b28e953601785467cdf8ca67dd5b0ef55105.camel@kernel.org>
 <YfAdtAaUfz38xtmf@redhat.com>
 <2f1c3741-df38-1179-5e3f-4cd1c4516e76@schaufler-ca.com>
 <CAHC9VhRgKZDzyNOhd-0nmKxBdnzQW5FHRwg9hHjGrUEPMhqaDg@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhRgKZDzyNOhd-0nmKxBdnzQW5FHRwg9hHjGrUEPMhqaDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.19615 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/25/2022 11:57 AM, Paul Moore wrote:
> On Tue, Jan 25, 2022 at 12:09 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 1/25/2022 7:56 AM, Vivek Goyal wrote:
>>> On Tue, Jan 25, 2022 at 07:32:19AM -0500, Jeff Layton wrote:
>>>> On Tue, 2022-01-25 at 13:12 +0100, Christian Brauner wrote:
>>>>> On Tue, Jan 25, 2022 at 06:25:39AM -0500, Jeff Layton wrote:
>>>>>> On Tue, 2022-01-25 at 12:13 +0100, Christian Brauner wrote:
>>>>>>> On Tue, Jan 25, 2022 at 05:54:57AM -0500, Jeff Layton wrote:
>>>>>>>> On Mon, 2022-01-24 at 21:45 -0500, Paul Moore wrote:
>>>>>>>>> On Mon, Jan 24, 2022 at 8:51 PM Stephen Muth <smuth4@gmail.com> wrote:
> ...
>
>> Joining the conversation late. Wish someone had brought me
>> in sooner.
> For some reason I thought the LSM list was on the To/CC line, my
> mistake (fixed now).
>
> Thanks to everyone for all of the further discussion, review on this;
> I plucked the original post out of my spam folder as I was shutting
> down for the night yesterday and only gave it a quick look.
>
>>> Looks like dentry_init_security() can't handle multiple LSMs. We probably
>>> should disallow all other LSMs to register a hook for this and only
>>> allow SELinux to register a hook.
>> Not acceptable. The fix to dentry_init_security() is easy.
> Sounds good to me, Vivek did you want to put together a patch for
> this?  If not, let me know and I'll put one together.

Thank you. I'd do it myself, but I'm dealing with pain meds and a
hinky keyboard. Rarely a great start for a good patch.

