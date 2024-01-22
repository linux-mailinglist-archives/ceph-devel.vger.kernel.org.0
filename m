Return-Path: <ceph-devel+bounces-602-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FBB0836275
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 12:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E13E528EDDA
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 11:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8D73A8F7;
	Mon, 22 Jan 2024 11:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MF+yVpki"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5527E3A1DE
	for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 11:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705923895; cv=none; b=A1NMANiPW5Q1LRn7pI5K/QJhk2kUr9K6so2pw4G+vaRZ++M+FWYbv6druTS3kaLYIgrZ7bEEeNWxFfzNsnxZFTpAfR0RWWeOu28GYysk1Rdpr8PUwx1VhrUVQbyCMHpWy+toYgB/NcdElt3zJmLp0z5aTBXOi8wXYQRUED7K9Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705923895; c=relaxed/simple;
	bh=5BD3UBmMH37ak9NF8wQbzObxT9UWgDWRHJQ/JNev/hs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vd3fp8OC9L6+3iADX8HEvzI0vBjqq/L1x25M/0dt6A5dZnRBz9YhMm4LpW7sIwsoroBrsOlzTIQzAzgne3ow96IsSjDJkbI1mt4qWpBfXv7+pMMz+zVutZ1B/BYH0TsvciWa2FUJSghPi+O31l2zKKm1ux75g75f0hDQ7JzQep4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MF+yVpki; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CDCC43390;
	Mon, 22 Jan 2024 11:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705923894;
	bh=5BD3UBmMH37ak9NF8wQbzObxT9UWgDWRHJQ/JNev/hs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=MF+yVpkim+FA5X40h7n5ND9WoMu/dn6htgfII0jAH/QIZrHgqxrMl8yFJ2V70C9aJ
	 FaspndNrYGdjufPKVTg6bLBelDObRj/9c94qhDAtN+Z4vl8JiyanI7PxxjXTgLNZl9
	 SfNaUYpS7X1N5sgftovvvVc8ICDyahiOKkL1/j5VHpNQiz5IAroF0pFmbTqAvxVJrb
	 SOlBksfels335nEI2CdBNXeSsM0fm9chjx0vfGlr7kA0GtkSJMN81RfpA+n//zj0pu
	 IjVo6tAv7mY9ITZIKfhWsCuYSYDvFohFzxrpyupQFdR3bHARLvXqcSJ7ZIm6GX1Crn
	 7AC5XhanCxGNw==
Message-ID: <790f0bc4f1f9c20dac6a43ec71d3b92781ab98b0.camel@kernel.org>
Subject: Re: [PATCH v4 3/3] libceph: just wait for more data to be available
 on the socket
From: Jeff Layton <jlayton@kernel.org>
To: Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
Date: Mon, 22 Jan 2024 06:44:53 -0500
In-Reply-To: <ef23a41a-65c1-476d-b8e6-ebf1fe654c57@redhat.com>
References: <20240118105047.792879-1-xiubli@redhat.com>
	 <20240118105047.792879-4-xiubli@redhat.com>
	 <ca7f6ba894524474d513807a165f02f4ad50a506.camel@kernel.org>
	 <ede93dec-3faf-48d1-859e-5edf4323fd15@redhat.com>
	 <f0c7ec2741851ff71e77f2e7598c0de665cce4ac.camel@kernel.org>
	 <ef23a41a-65c1-476d-b8e6-ebf1fe654c57@redhat.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=mQINBE6V0TwBEADXhJg7s8wFDwBMEvn0qyhAnzFLTOCHooMZyx7XO7dAiIhDSi7G1NPxwn8jdFUQMCR/GlpozMFlSFiZXiObE7sef9rTtM68ukUyZM4pJ9l0KjQNgDJ6Fr342Htkjxu/kFV1WvegyjnSsFt7EGoDjdKqr1TS9syJYFjagYtvWk/UfHlW09X+jOh4vYtfX7iYSx/NfqV3W1D7EDi0PqVT2h6v8i8YqsATFPwO4nuiTmL6I40ZofxVd+9wdRI4Db8yUNA4ZSP2nqLcLtFjClYRBoJvRWvsv4lm0OX6MYPtv76hka8lW4mnRmZqqx3UtfHX/hF/zH24Gj7A6sYKYLCU3YrI2Ogiu7/ksKcl7goQjpvtVYrOOI5VGLHge0awt7bhMCTM9KAfPc+xL/ZxAMVWd3NCk5SamL2cE99UWgtvNOIYU8m6EjTLhsj8snVluJH0/RcxEeFbnSaswVChNSGa7mXJrTR22lRL6ZPjdMgS2Km90haWPRc8Wolcz07Y2se0xpGVLEQcDEsvv5IMmeMe1/qLZ6NaVkNuL3WOXvxaVT9USW1+/SGipO2IpKJjeDZfehlB/kpfF24+RrK+seQfCBYyUE8QJpvTZyfUHNYldXlrjO6n5MdOempLqWpfOmcGkwnyNRBR46g/jf8KnPRwXs509yAqDB6sELZH+yWr9LQZEwARAQABtCVKZWZmIExheXRvbiA8amxheXRvbkBwb29jaGllcmVkcy5uZXQ+iQI7BBMBAgAlAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAUCTpXWPAIZAQAKCRAADmhBGVaCFc65D/4gBLNMHopQYgG/9RIM3kgFCCQV0pLv0hcg1cjr+bPI5f1PzJoOVi9s0wBDHwp8+vtHgYhM54yt43uI7Htij0RHFL5eFqoVT4TSfAg2qlvNemJEOY0e4daljjmZM7UtmpGs9NN0r9r50W82eb5Kw5bc/
	r0kmR/arUS2st+ecRsCnwAOj6HiURwIgfDMHGPtSkoPpu3DDp/cjcYUg3HaOJuTjtGHFH963B+f+hyQ2BrQZBBE76ErgTDJ2Db9Ey0kw7VEZ4I2nnVUY9B5dE2pJFVO5HJBMp30fUGKvwaKqYCU2iAKxdmJXRIONb7dSde8LqZahuunPDMZyMA5+mkQl7kpIpR6kVDIiqmxzRuPeiMP7O2FCUlS2DnJnRVrHmCljLkZWf7ZUA22wJpepBligemtSRSbqCyZ3B48zJ8g5B8xLEntPo/NknSJaYRvfEQqGxgk5kkNWMIMDkfQOlDSXZvoxqU9wFH/9jTv1/6p8dHeGM0BsbBLMqQaqnWiVt5mG92E1zkOW69LnoozE6Le+12DsNW7RjiR5K+27MObjXEYIW7FIvNN/TQ6U1EOsdxwB8o//Yfc3p2QqPr5uS93SDDan5ehH59BnHpguTc27XiQQZ9EGiieCUx6Zh2ze3X2UW9YNzE15uKwkkuEIj60NvQRmEDfweYfOfPVOueC+iFifbQgSmVmZiBMYXl0b24gPGpsYXl0b25AcmVkaGF0LmNvbT6JAjgEEwECACIFAk6V0q0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEAAOaEEZVoIViKUQALpvsacTMWWOd7SlPFzIYy2/fjvKlfB/Xs4YdNcf9qLqF+lk2RBUHdR/dGwZpvw/OLmnZ8TryDo2zXVJNWEEUFNc7wQpl3i78r6UU/GUY/RQmOgPhs3epQC3PMJj4xFx+VuVcf/MXgDDdBUHaCTT793hyBeDbQuciARDJAW24Q1RCmjcwWIV/pgrlFa4lAXsmhoac8UPc82Ijrs6ivlTweFf16VBc4nSLX5FB3ls7S5noRhm5/Zsd4PGPgIHgCZcPgkAnU1S/A/rSqf3FLpU+CbVBDvlVAnOq9gfNF+QiTlOHdZVIe4gEYAU3CUjbleywQqV02BKxPVM0C5/oVjMVx
	3bri75n1TkBYGmqAXy9usCkHIsG5CBHmphv9MHmqMZQVsxvCzfnI5IO1+7MoloeeW/lxuyd0pU88dZsV/riHw87i2GJUJtVlMl5IGBNFpqoNUoqmvRfEMeXhy/kUX4Xc03I1coZIgmwLmCSXwx9MaCPFzV/dOOrju2xjO+2sYyB5BNtxRqUEyXglpujFZqJxxau7E0eXoYgoY9gtFGsspzFkVNntamVXEWVVgzJJr/EWW0y+jNd54MfPRqH+eCGuqlnNLktSAVz1MvVRY1dxUltSlDZT7P2bUoMorIPu8p7ZCg9dyX1+9T6Muc5dHxf/BBP/ir+3e8JTFQBFOiLNdFtB9KZWZmIExheXRvbiA8amxheXRvbkBzYW1iYS5vcmc+iQI4BBMBAgAiBQJOldK9AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRAADmhBGVaCFWgWD/0ZRi4hN9FK2BdQs9RwNnFZUr7JidAWfCrs37XrA/56olQl3ojn0fQtrP4DbTmCuh0SfMijB24psy1GnkPepnaQ6VRf7Dxg/Y8muZELSOtsv2CKt3/02J1BBitrkkqmHyni5fLLYYg6fub0T/8Kwo1qGPdu1hx2BQRERYtQ/S5d/T0cACdlzi6w8rs5f09hU9Tu4qV1JLKmBTgUWKN969HPRkxiojLQziHVyM/weR5Reu6FZVNuVBGqBD+sfk/c98VJHjsQhYJijcsmgMb1NohAzwrBKcSGKOWJToGEO/1RkIN8tqGnYNp2G+aR685D0chgTl1WzPRM6mFG1+n2b2RR95DxumKVpwBwdLPoCkI24JkeDJ7lXSe3uFWISstFGt0HL8EewP8RuGC8s5h7Ct91HMNQTbjgA+Vi1foWUVXpEintAKgoywaIDlJfTZIl6Ew8ETN/7DLy8bXYgq0XzhaKg3CnOUuGQV5/nl4OAX/3jocT5Cz/OtAiNYj5mLPeL5z2ZszjoCAH6caqsF2oLyA
	nLqRgDgR+wTQT6gMhr2IRsl+cp8gPHBwQ4uZMb+X00c/Amm9VfviT+BI7B66cnC7Zv6Gvmtu2rEjWDGWPqUgccB7hdMKnKDthkA227/82tYoFiFMb/NwtgGrn5n2vwJyKN6SEoygGrNt0SI84y6hEVbQlSmVmZiBMYXl0b24gPGpsYXl0b25AcHJpbWFyeWRhdGEuY29tPokCOQQTAQIAIwUCU4xmKQIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEAAOaEEZVoIV1H0P/j4OUTwFd7BBbpoSp695qb6HqCzWMuExsp8nZjruymMaeZbGr3OWMNEXRI1FWNHMtcMHWLP/RaDqCJil28proO+PQ/yPhsr2QqJcW4nr91tBrv/MqItuAXLYlsgXqp4BxLP67bzRJ1Bd2x0bWXurpEXY//VBOLnODqThGEcL7jouwjmnRh9FTKZfBDpFRaEfDFOXIfAkMKBa/c9TQwRpx2DPsl3eFWVCNuNGKeGsirLqCxUg5kWTxEorROppz9oU4HPicL6rRH22Ce6nOAON2vHvhkUuO3GbffhrcsPD4DaYup4ic+DxWm+DaSSRJ+e1yJvwi6NmQ9P9UAuLG93S2MdNNbosZ9P8k2mTOVKMc+GooI9Ve/vH8unwitwo7ORMVXhJeU6Q0X7zf3SjwDq2lBhn1DSuTsn2DbsNTiDvqrAaCvbsTsw+SZRwF85eG67eAwouYk+dnKmp1q57LDKMyzysij2oDKbcBlwB/TeX16p8+LxECv51asjS9TInnipssssUDrHIvoTTXWcz7Y5wIngxDFwT8rPY3EggzLGfK5Zx2Q5S/N0FfmADmKknG/D8qGIcJE574D956tiUDKN4I+/g125ORR1v7bP+OIaayAvq17RP+qcAqkxc0x8iCYVCYDouDyNvWPGRhbLUO7mlBpjW9jK9e2fvZY9iw3QzIPGKtClKZWZmIExheXRvbiA8amVmZi5sYXl0
	b25AcHJpbWFyeWRhdGEuY29tPokCOQQTAQIAIwUCU4xmUAIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEAAOaEEZVoIVzJoQALFCS6n/FHQS+hIzHIb56JbokhK0AFqoLVzLKzrnaeXhE5isWcVg0eoV2oTScIwUSUapy94if69tnUo4Q7YNt8/6yFM6hwZAxFjOXR0ciGE3Q+Z1zi49Ox51yjGMQGxlakV9ep4sV/d5a50M+LFTmYSAFp6HY23JN9PkjVJC4PUv5DYRbOZ6Y1+TfXKBAewMVqtwT1Y+LPlfmI8dbbbuUX/kKZ5ddhV2736fgyfpslvJKYl0YifUOVy4D1G/oSycyHkJG78OvX4JKcf2kKzVvg7/Rnv+AueCfFQ6nGwPn0P91I7TEOC4XfZ6a1K3uTp4fPPs1Wn75X7K8lzJP/p8lme40uqwAyBjk+IA5VGd+CVRiyJTpGZwA0jwSYLyXboX+Dqm9pSYzmC9+/AE7lIgpWj+3iNisp1SWtHc4pdtQ5EU2SEz8yKvDbD0lNDbv4ljI7eflPsvN6vOrxz24mCliEco5DwhpaaSnzWnbAPXhQDWb/lUgs/JNk8dtwmvWnqCwRqElMLVisAbJmC0BhZ/Ab4sph3EaiZfdXKhiQqSGdK4La3OTJOJYZphPdGgnkvDV9Pl1QZ0ijXQrVIy3zd6VCNaKYq7BAKidn5g/2Q8oio9Tf4XfdZ9dtwcB+bwDJFgvvDYaZ5bI3ln4V3EyW5i2NfXazz/GA/I/ZtbsigCFc8ftCBKZWZmIExheXRvbiA8amxheXRvbkBrZXJuZWwub3JnPokCOAQTAQIAIgUCWe8u6AIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQAA5oQRlWghUuCg/+Lb/xGxZD2Q1oJVAE37uW308UpVSD2tAMJUvFTdDbfe3zKlPDTuVsyNsALBGclPLagJ5ZTP+Vp2irAN9uwBuac
	BOTtmOdz4ZN2tdvNgozzuxp4CHBDVzAslUi2idy+xpsp47DWPxYFIRP3M8QG/aNW052LaPc0cedYxp8+9eiVUNpxF4SiU4i9JDfX/sn9XcfoVZIxMpCRE750zvJvcCUz9HojsrMQ1NFc7MFT1z3MOW2/RlzPcog7xvR5ENPH19ojRDCHqumUHRry+RF0lH00clzX/W8OrQJZtoBPXv9ahka/Vp7kEulcBJr1cH5Wz/WprhsIM7U9pse1f1gYy9YbXtWctUz8uvDR7shsQxAhX3qO7DilMtuGo1v97I/Kx4gXQ52syh/w6EBny71CZrOgD6kJwPVVAaM1LRC28muq91WCFhs/nzHozpbzcheyGtMUI2Ao4K6mnY+3zIuXPygZMFr9KXE6fF7HzKxKuZMJOaEZCiDOq0anx6FmOzs5E6Jqdpo/mtI8beK+BE7Va6ni7YrQlnT0i3vaTVMTiCThbqsB20VrbMjlhpf8lfK1XVNbRq/R7GZ9zHESlsa35ha60yd/j3pu5hT2xyy8krV8vGhHvnJ1XRMJBAB/UYb6FyC7S+mQZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65ke5Ag0ETpXRPAEQAJkVmzCmF+IEenf9a2nZRXMluJohnfl2wCMmw5qNzyk0f+mYuTwTCpw7BE2H0yXk4ZfAuA+xdj14K0A1Dj52j/fKRuDqoNAhQe0b6ipo85Sz98G+XnmQOMeFVp5G1Z7r/QP/nus3mXvtFsu9lLSjMA0cam2NLDt7vx3l9kUYlQBhyIE7/DkKg+3fdqRg7qJoMHNcODtQY+n3hMyaVpplJ/l0DdQDbRSZi5AzDM3DWZEShhuP6/E2LN4O3xWnZukEiz688d1ppl7vBZO9wBql6Ft9Og74diZrTN6lXGGjEWRvO55h6ijMsLCLNDRAVehPhZvSlPldtUuvhZLAjdWpwmzbRIwgoQcO51aWeKthpcpj8feDdKdlVjvJO9fgFD5kqZ
	QiErRVPpB7VzA/pYV5Mdy7GMbPjmO0IpoL0tVZ8JvUzUZXB3ErS/dJflvboAAQeLpLCkQjqZiQ/DCmgJCrBJst9Xc7YsKKS379Tc3GU33HNSpaOxs2NwfzoesyjKU+P35czvXWTtj7KVVSj3SgzzFk+gLx8y2Nvt9iESdZ1Ustv8tipDsGcvIZ43MQwqU9YbLg8k4V9ch+Mo8SE+C0jyZYDCE2ZGf3OztvtSYMsTnF6/luzVyej1AFVYjKHORzNoTwdHUeC+9/07GO0bMYTPXYvJ/vxBFm3oniXyhgb5FtABEBAAGJAh8EGAECAAkFAk6V0TwCGwwACgkQAA5oQRlWghXhZRAAyycZ2DDyXh2bMYvI8uHgCbeXfL3QCvcw2XoZTH2l2umPiTzrCsDJhgwZfG9BDyOHaYhPasd5qgrUBtjjUiNKjVM+Cx1DnieR0dZWafnqGv682avPblfi70XXr2juRE/fSZoZkyZhm+nsLuIcXTnzY4D572JGrpRMTpNpGmitBdh1l/9O7Fb64uLOtA5Qj5jcHHOjL0DZpjmFWYKlSAHmURHrE8M0qRryQXvlhoQxlJR4nvQrjOPMsqWD5F9mcRyowOzr8amasLv43w92rD2nHoBK6rbFE/qC7AAjABEsZq8+TQmueN0maIXUQu7TBzejsEbV0i29z+kkrjU2NmK5pcxgAtehVxpZJ14LqmN6E0suTtzjNT1eMoqOPrMSx+6vOCIuvJ/MVYnQgHhjtPPnU86mebTY5Loy9YfJAC2EVpxtcCbx2KiwErTndEyWL+GL53LuScUD7tW8vYbGIp4RlnUgPLbqpgssq2gwYO9m75FGuKuB2+2bCGajqalid5nzeq9v7cYLLRgArJfOIBWZrHy2m0C+pFu9DSuV6SNr2dvMQUv1V58h0FaSOxHVQnJdnoHn13g/CKKvyg2EMrMt/EfcXgvDwQbnG9we4xJiWOIOcsvrWcB6C6lWBDA+In7w7SXnnok
	kZWuOsJdJQdmwlWC5L5ln9xgfr/4mOY38B0U=
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-01-22 at 10:52 +0800, Xiubo Li wrote:
> On 1/19/24 19:09, Jeff Layton wrote:
> > On Fri, 2024-01-19 at 12:35 +0800, Xiubo Li wrote:
> > > On 1/19/24 02:24, Jeff Layton wrote:
> > > > On Thu, 2024-01-18 at 18:50 +0800, xiubli@redhat.com wrote:
> > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > >=20
> > > > > The messages from ceph maybe split into multiple socket packages
> > > > > and we just need to wait for all the data to be availiable on the
> > > > > sokcet.
> > > > >=20
> > > > > This will add 'sr_total_resid' to record the total length for all
> > > > > data items for sparse-read message and 'sr_resid_elen' to record
> > > > > the current extent total length.
> > > > >=20
> > > > > URL: https://tracker.ceph.com/issues/63586
> > > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > > ---
> > > > >    include/linux/ceph/messenger.h |  1 +
> > > > >    net/ceph/messenger_v1.c        | 32 +++++++++++++++++++++-----=
------
> > > > >    2 files changed, 22 insertions(+), 11 deletions(-)
> > > > >=20
> > > > > diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/=
messenger.h
> > > > > index 2eaaabbe98cb..ca6f82abed62 100644
> > > > > --- a/include/linux/ceph/messenger.h
> > > > > +++ b/include/linux/ceph/messenger.h
> > > > > @@ -231,6 +231,7 @@ struct ceph_msg_data {
> > > > >   =20
> > > > >    struct ceph_msg_data_cursor {
> > > > >    	size_t			total_resid;	/* across all data items */
> > > > > +	size_t			sr_total_resid;	/* across all data items for sparse-re=
ad */
> > > > >   =20
> > > > >    	struct ceph_msg_data	*data;		/* current data item */
> > > > >    	size_t			resid;		/* bytes not yet consumed */
> > > > > diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> > > > > index 4cb60bacf5f5..2733da891688 100644
> > > > > --- a/net/ceph/messenger_v1.c
> > > > > +++ b/net/ceph/messenger_v1.c
> > > > > @@ -160,7 +160,9 @@ static size_t sizeof_footer(struct ceph_conne=
ction *con)
> > > > >    static void prepare_message_data(struct ceph_msg *msg, u32 dat=
a_len)
> > > > >    {
> > > > >    	/* Initialize data cursor if it's not a sparse read */
> > > > > -	if (!msg->sparse_read)
> > > > > +	if (msg->sparse_read)
> > > > > +		msg->cursor.sr_total_resid =3D data_len;
> > > > > +	else
> > > > >    		ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
> > > > >    }
> > > > >   =20
> > > > > @@ -1032,35 +1034,43 @@ static int read_partial_sparse_msg_data(s=
truct ceph_connection *con)
> > > > >    	bool do_datacrc =3D !ceph_test_opt(from_msgr(con->msgr), NOCR=
C);
> > > > >    	u32 crc =3D 0;
> > > > >    	int ret =3D 1;
> > > > > +	int len;
> > > > >   =20
> > > > >    	if (do_datacrc)
> > > > >    		crc =3D con->in_data_crc;
> > > > >   =20
> > > > > -	do {
> > > > > -		if (con->v1.in_sr_kvec.iov_base)
> > > > > +	while (cursor->sr_total_resid) {
> > > > > +		len =3D 0;
> > > > > +		if (con->v1.in_sr_kvec.iov_base) {
> > > > > +			len =3D con->v1.in_sr_kvec.iov_len;
> > > > >    			ret =3D read_partial_message_chunk(con,
> > > > >    							 &con->v1.in_sr_kvec,
> > > > >    							 con->v1.in_sr_len,
> > > > >    							 &crc);
> > > > > -		else if (cursor->sr_resid > 0)
> > > > > +			len =3D con->v1.in_sr_kvec.iov_len - len;
> > > > > +		} else if (cursor->sr_resid > 0) {
> > > > > +			len =3D cursor->sr_resid;
> > > > >    			ret =3D read_partial_sparse_msg_extent(con, &crc);
> > > > > -
> > > > > -		if (ret <=3D 0) {
> > > > > -			if (do_datacrc)
> > > > > -				con->in_data_crc =3D crc;
> > > > > -			return ret;
> > > > > +			len -=3D cursor->sr_resid;
> > > > >    		}
> > > > > +		cursor->sr_total_resid -=3D len;
> > > > > +		if (ret <=3D 0)
> > > > > +			break;
> > > > >   =20
> > > > >    		memset(&con->v1.in_sr_kvec, 0, sizeof(con->v1.in_sr_kvec));
> > > > >    		ret =3D con->ops->sparse_read(con, cursor,
> > > > >    				(char **)&con->v1.in_sr_kvec.iov_base);
> > > > > +		if (ret <=3D 0) {
> > > > > +			ret =3D ret ? : 1; /* must return > 0 to indicate success */
> > > > > +			break;
> > > > > +		}
> > > > >    		con->v1.in_sr_len =3D ret;
> > > > > -	} while (ret > 0);
> > > > > +	}
> > > > >   =20
> > > > >    	if (do_datacrc)
> > > > >    		con->in_data_crc =3D crc;
> > > > >   =20
> > > > > -	return ret < 0 ? ret : 1;  /* must return > 0 to indicate succe=
ss */
> > > > > +	return ret;
> > > > >    }
> > > > >   =20
> > > > >    static int read_partial_msg_data(struct ceph_connection *con)
> > > > Looking back over this code...
> > > >=20
> > > > The way it works today, once we determine it's a sparse read, we ca=
ll
> > > > read_sparse_msg_data. At that point we call either
> > > > read_partial_message_chunk (to read into the kvec) or
> > > > read_sparse_msg_extent if sr_resid is already set (indicating that =
we're
> > > > receiving an extent).
> > > >=20
> > > > read_sparse_msg_extent calls ceph_tcp_recvpage in a loop until
> > > > cursor->sr_resid have been received. The exception there when
> > > > ceph_tcp_recvpage returns <=3D 0.
> > > >=20
> > > > ceph_tcp_recvpage returns 0 if sock_recvmsg returns -EAGAIN (maybe =
also
> > > > in other cases). So it sounds like the client just timed out on a r=
ead
> > > > from the socket or caught a signal or something?
> > > >=20
> > > > If that's correct, then do we know what ceph_tcp_recvpage returned =
when
> > > > the problem happened?
> > > It should just return parital data, and we should continue from here =
in
> > > the next loop when the reset data comes.
> > >=20
> > Tracking this extra length seems like the wrong fix. We're already
> > looping in read_sparse_msg_extent until the sr_resid goes to 0.
> Yeah, it is and it works well.
> >   ISTM
> > that it's just that read_sparse_msg_extent is returning inappropriately
> > in the face of timeouts.
> >=20
> > IOW, it does this:
> >=20
> >                  ret =3D ceph_tcp_recvpage(con->sock, rpage, (int)off, =
len);
> >                  if (ret <=3D 0)
> >                          return ret;
> >=20
> > ...should it just not be returning there when ret =3D=3D 0? Maybe it sh=
ould
> > be retrying the recvpage instead?
>=20
> Currently the the ceph_tcp_recvpage() will read data without blocking.=
=20

Yes.

> If so we will change the logic here then all the other non-sparse-read=
=20
> cases will be changed to.
>=20

No. read_sparse_msg_data is only called from the sparse-read codepath.
If we change it, only that will be affected.


> Please note this won't fix anything here in this bug.
>=20
> Because currently the sparse-read code works well if in step 4 it=20
> partially read the sparse-read data or extents.
>=20
> But in case of partially reading 'footer' in step 5. What we need to=20
> guarantee is that in the second loop we could skip triggering a new=20
> sparse-read in step 4:
>=20
> 1, /* header */=A0=A0=A0=A0=A0=A0=A0=A0 =3D=3D=3D> will skip and do nothi=
ng if it has already=20
> read the 'header' data in last loop
>=20
> 2, /* front */=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D=3D=3D> will skip a=
nd do nothing if it has=20
> already read the 'front' data in last loop
>=20
> 3, /* middle */=A0=A0=A0=A0=A0=A0=A0=A0 =3D=3D=3D> will skip and do nothi=
ng if it has already=20
> read the 'middle' data in last loop
>=20
> 4, /* (page) data */=A0=A0 =3D=3D=3D> sparse-read here, it also should sk=
ip and do=20
> nothing if it has already read the whole 'sparse-read' data in last=20
> loop, but it won't. This is the ROOT CAUSE of this bug.
>=20
> 5, /* footer */=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D=3D=3D> the 'read_par=
tial()' will only read=20
> partial 'footer' data then need to loop start from /* header */ when the=
=20
> data comes
>=20
> My patch could guarantee that the sparse-read code will do nothing.=20
> While currently the code will trigger a new sparse-read from beginning=
=20
> again, which is incorrect.
>=20
> Jeff, please let me know if you have better approaches.=A0 The last one=
=20
> Ilya mentioned didn't work.

Your patch tries to track sr_resid independently in a new variable
sr_total_resid, but I think that's unnecessary.

read_sparse_msg_data returns under two conditions:

1. It has read all of the sparse read data (i.e. sr_resid is 0), in
which case it returns 1.

...or...

2. ceph_tcp_recvpage returns a negative error code or 0.

After your patch, the only way you'd get a case where sr_total_resid
is >0 is if case #2 happens. Clearly if we receive all of the data then
sr_total_resid will also be 0.

We want to return an error if there is a hard error from
ceph_tcp_recvpage, but it looks like it also returns 0 if the socket
read returns -EAGAIN. So, it seems to be that doing something like this
would be a sufficient fix. What am I missing?

diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index f9a50d7f0d20..cf94ebdb3b34 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -1015,8 +1015,10 @@ static int read_sparse_msg_extent(struct ceph_connec=
tion *con, u32 *crc)
                /* clamp to what remains in extent */
                len =3D min_t(int, len, cursor->sr_resid);
                ret =3D ceph_tcp_recvpage(con->sock, rpage, (int)off, len);
-               if (ret <=3D 0)
+               if (ret < 0)
                        return ret;
+               else if (ret =3D=3D 0)
+                       continue;
                *crc =3D ceph_crc32c_page(*crc, rpage, off, ret);
                ceph_msg_data_advance(cursor, (size_t)ret);
                cursor->sr_resid -=3D ret;

--=20
Jeff Layton <jlayton@kernel.org>

